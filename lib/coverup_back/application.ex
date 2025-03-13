defmodule CoverupBack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CoverupBackWeb.Telemetry,
      CoverupBack.Repo,
      {DNSCluster, query: Application.get_env(:coverup_back, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CoverupBack.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CoverupBack.Finch},
      # Start a worker by calling: CoverupBack.Worker.start_link(arg)
      # {CoverupBack.Worker, arg},
      # Start to serve requests, typically the last entry
      CoverupBackWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoverupBack.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CoverupBackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
