defmodule CoverupBack.Repo.Migrations.MakeTextToResumes do
  use Ecto.Migration

  def change do
    alter table(:resumes) do
      modify :summary, :text
      modify :education, :text
      modify :work, :text
      modify :projects, :text
      modify :achievements, :text
      modify :other, :text
    end
  end
end
