defmodule GoblinPay.Repo do
  use Ecto.Repo,
    otp_app: :goblin_pay,
    adapter: Ecto.Adapters.Postgres
end
