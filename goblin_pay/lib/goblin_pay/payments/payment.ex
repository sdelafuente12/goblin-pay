defmodule GoblinPay.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :amount_applied, :integer
    belongs_to :order, GoblinPay.Orders.Order
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount_applied, :order_id])
    |> validate_required([:amount_applied, :order_id])
  end
end
