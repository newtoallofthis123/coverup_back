defmodule CoverupBack.Resume do
  alias CoverupBack.Repo
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :other,
             :user_id,
             :first_name,
             :last_name,
             :email,
             :phone,
             :social,
             :summary,
             :education,
             :skills,
             :work,
             :projects,
             :achievements
           ]}
  schema "resumes" do
    field :other, :map
    field :user_id, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :social, :map
    field :summary, :string
    field :education, :map
    field :skills, :string
    field :work, :map
    field :projects, :map
    field :achievements, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(resume, attrs) do
    resume
    |> cast(attrs, [
      :user_id,
      :first_name,
      :last_name,
      :email,
      :phone,
      :social,
      :summary,
      :education,
      :skills,
      :work,
      :projects,
      :achievements,
      :other
    ])
    |> validate_required([:first_name, :last_name, :email, :phone, :summary, :skills, :user_id])
  end

  def create(attrs) do
    validated = changeset(%CoverupBack.Resume{}, attrs)

    case validated do
      %Ecto.Changeset{valid?: true} ->
        Repo.insert!(validated)

      _ ->
        nil
    end
  end

  def get(id) do
    Repo.get(CoverupBack.Resume, id)
  end

  def get_by_user(user_id) do
    Repo.get_by(CoverupBack.Resume, user_id: user_id)
  end

  def update(id, attrs) do
    resume = get(id)

    case resume do
      nil ->
        Repo.insert(changeset(%CoverupBack.Resume{}, attrs))

      resume_data ->
        validated = changeset(resume_data, attrs)

        case validated do
          %Ecto.Changeset{valid?: true} ->
            Repo.update!(validated)

          _ ->
            nil
        end
    end
  end

  def delete(id) do
    Repo.delete(CoverupBack.Resume, id)
  end
end
