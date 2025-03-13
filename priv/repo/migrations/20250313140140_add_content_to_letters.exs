defmodule CoverupBack.Repo.Migrations.AddContentToLetters do
  use Ecto.Migration

  def change do
    alter table(:letters) do
      add :content, :text
    end
  end
end
