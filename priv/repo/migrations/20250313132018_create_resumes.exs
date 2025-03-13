defmodule CoverupBack.Repo.Migrations.CreateResumes do
  use Ecto.Migration

  def change do
    create table(:resumes) do
      add :first_name, :string
      add :last_name, :string
      add :title, :string
      add :email, :string
      add :address, :string
      add :phone, :string
      add :social, :map
      add :summary, :string
      add :education, :map
      add :skills, :string
      add :work, :map
      add :projects, :map
      add :achievements, :map
      add :other, :map
      add :user_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
