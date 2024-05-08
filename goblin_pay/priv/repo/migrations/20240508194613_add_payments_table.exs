defmodule GoblinPay.Repo.Migrations.AddPaymentsTable do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount_applied, :integer
    end
  end
end
