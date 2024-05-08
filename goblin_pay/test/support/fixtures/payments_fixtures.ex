defmodule GoblinPay.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GoblinPay.Payments` context.
  """
  import GoblinPay.OrdersFixtures

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    order = order_fixture()

    {:ok, payment} =
      attrs
      |> Enum.into(%{
        "amount_applied" => 10,
        "order_id" => order.id
      })
      |> GoblinPay.Payments.create_payment()

    payment
  end
end
