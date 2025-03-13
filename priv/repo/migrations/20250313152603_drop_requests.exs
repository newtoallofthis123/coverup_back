defmodule CoverupBack.Repo.Migrations.DropRequests do
  use Ecto.Migration

  def change do
    drop table(:requests)
  end
end
