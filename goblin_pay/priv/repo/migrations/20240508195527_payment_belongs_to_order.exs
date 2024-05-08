defmodule GoblinPay.Repo.Migrations.PaymentBelongsToOrder do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :order_id, references(:orders)
    end
  end
end
