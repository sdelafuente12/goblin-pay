defmodule GoblinPay.Orders.Order do
  alias GoblinPay.Orders.Order
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  schema "orders" do
    field :email_address, :string
    field :original_order_value, :integer
    field :current_balance, :integer
    has_many :payments, GoblinPay.Payments.Payment
  end

  def get_and_lock_order(query \\ Order, order_id) do
    from(o in query,
      where: o.id == ^order_id,
      lock: "FOR UPDATE NOWAIT"
    )
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:email_address, :original_order_value, :current_balance])
    |> validate_required([:email_address, :original_order_value, :current_balance])
  end
end
