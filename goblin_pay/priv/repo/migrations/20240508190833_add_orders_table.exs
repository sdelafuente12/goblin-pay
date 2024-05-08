defmodule GoblinPay.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :email_address, :string
      add :original_order_value, :integer
      add :current_balance, :integer
    end
  end
end
