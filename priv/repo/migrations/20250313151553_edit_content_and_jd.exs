defmodule CoverupBack.Repo.Migrations.EditContentAndJd do
  use Ecto.Migration

  def change do
    alter table(:letters) do
      modify :content, :text
      modify :job_description, :text
    end
  end
end
