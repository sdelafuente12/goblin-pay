defmodule GoblinPay.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :email_address, :string
    field :original_order_value, :integer
    field :current_balance, :integer
    has_many :payments, GoblinPay.Payments.Payment
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:email_address, :original_order_value, :current_balance])
    |> validate_required([:email_address, :original_order_value, :current_balance])
  end
end
