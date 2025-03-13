defmodule CoverupBack.Repo.Migrations.CreateLetters do
  use Ecto.Migration

  def change do
    create table(:letters) do
      add :job_description, :string
      add :title, :string
      add :resume_id, :string
      add :user_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
