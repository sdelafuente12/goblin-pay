defmodule GoblinPay.OrdersTest do
  use GoblinPay.DataCase

  alias GoblinPay.Orders

  describe "orders" do
    alias GoblinPay.Orders.Order

    import GoblinPay.OrdersFixtures

    @invalid_attrs %{
      "email_address" => 34,
      "current_balance" => "string not integer",
      "original_order_value" => :atom_not_integer
    }

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "get_orders_for_customer/1 returns list of orders for a specific customer" do
      order1 = order_fixture(%{"email_address" => "multiordercustomer@goblinpay.com"})
      order2 = order_fixture(%{"email_address" => "multiordercustomer@goblinpay.com"})

      assert [order1, order2] ==
               Orders.get_orders_for_customer("multiordercustomer@goblinpay.com")
    end

    test "get_orders_for_customer/1 returns empty list if no orders for specified customer is found" do
      assert [] == Orders.get_orders_for_customer("noorderscustomer@goblinpay.com")
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        "email_address" => "customer@goblinpay.com",
        "current_balance" => 34,
        "original_order_value" => 66
      }

      assert {:ok,
              %Order{
                email_address: "customer@goblinpay.com",
                current_balance: 34,
                original_order_value: 66
              }} = Orders.create_order(valid_attrs)
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "create_order_and_pay/2 creates order and initial payment" do
      order_attrs = %{
        "email_address" => "orderandpay@goblinpay.com",
        "original_order_value" => 100,
        "current_balance" => 100
      }

      payment_amount = 20

      assert {:ok, %{original_order_value: 100, current_balance: 80}} =
               Orders.create_order_and_pay(order_attrs, payment_amount)
    end

    test "create_order_and_pay/2 with invalid data returns error changeset" do
      order_attrs = %{
        "email_address" => "orderandpay@goblinpay.com",
        "original_order_value" => "not a number",
        "current_balance" => 100
      }

      payment_amount = 20

      assert {:error, %Ecto.Changeset{}} =
               Orders.create_order_and_pay(order_attrs, payment_amount)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture(%{"email_address" => "oldcustomer@goblinpay.com"})
      update_attrs = %{"email_address" => "brandnewcustomer@goblinpay.com"}

      assert {:ok, %Order{email_address: "brandnewcustomer@goblinpay.com"}} =
               Orders.update_order(order, update_attrs)
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "apply_payment_to_order/2 applies a payment to a given order" do
      order = order_fixture(%{"current_balance" => 75})
      payment_amount = 50

      assert {:ok, %Order{current_balance: 25}} =
               Orders.apply_payment_to_order(payment_amount, order.id)
    end

    test "apply_payment_to_order/2 with invalid data returns error changeset" do
      order = order_fixture(%{"current_balance" => 75})
      payment_amount = :notaninteger

      assert {:error, %Ecto.Changeset{}} = Orders.apply_payment_to_order(payment_amount, order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
