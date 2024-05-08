defmodule GoblinPay.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoblinPay.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        "email_address" => "sam@goblinpay.com",
        "original_order_value" => 100,
        "current_balance" => 50
      })
      |> GoblinPay.Orders.create_order()

    order
  end
end
