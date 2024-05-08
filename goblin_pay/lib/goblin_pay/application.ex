defmodule GoblinPay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GoblinPayWeb.Telemetry,
      GoblinPay.Repo,
      {DNSCluster, query: Application.get_env(:goblin_pay, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GoblinPay.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GoblinPay.Finch},
      # Start a worker by calling: GoblinPay.Worker.start_link(arg)
      # {GoblinPay.Worker, arg},
      # Start to serve requests, typically the last entry
      GoblinPayWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GoblinPay.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GoblinPayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
