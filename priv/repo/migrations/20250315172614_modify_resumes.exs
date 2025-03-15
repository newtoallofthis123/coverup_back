defmodule CoverupBack.Repo.Migrations.ModifyResumes do
  use Ecto.Migration

  def change do
    alter table(:resumes) do
      modify :other, :string
      modify :education, :string
      modify :work, :string
      modify :projects, :string
      modify :achievements, :string
    end
  end
end
