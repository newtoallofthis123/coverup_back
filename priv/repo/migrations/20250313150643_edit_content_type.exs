defmodule CoverupBack.Repo.Migrations.EditContentType do
  use Ecto.Migration

  def change do
    # make content field to string
    alter table(:letters) do
      modify :content, :string
    end
  end
end
