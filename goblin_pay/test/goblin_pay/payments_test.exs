defmodule GoblinPay.PaymentsTest do
  use GoblinPay.DataCase

  alias GoblinPay.Payments

  describe "payments" do
    alias GoblinPay.Payments.Payment

    import GoblinPay.PaymentsFixtures
    import GoblinPay.OrdersFixtures

    @invalid_attrs %{"amount_applied" => "string not integer"}

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Payments.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Payments.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      order = order_fixture()
      valid_attrs = %{"amount_applied" => 20, "order_id" => order.id}

      assert {:ok, %Payment{amount_applied: 20}} = Payments.create_payment(valid_attrs)
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture(%{"amount_applied" => 200})
      update_attrs = %{"amount_applied" => 50}

      assert {:ok, %Payment{amount_applied: 50}} = Payments.update_payment(payment, update_attrs)
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment(payment, @invalid_attrs)
      assert payment == Payments.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment(payment)
    end
  end
end
