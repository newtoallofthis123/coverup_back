defmodule CoverupBack.Repo do
  use Ecto.Repo,
    otp_app: :coverup_back,
    adapter: Ecto.Adapters.Postgres
end
