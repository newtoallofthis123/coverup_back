defmodule CoverupBack.Letter do
  use Ecto.Schema
  alias CoverupBack.Repo
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :title,
             :job_description,
             :content,
             :resume_id,
             :user_id,
             :inserted_at
           ]}
  schema "letters" do
    field :title, :string
    field :job_description, :string
    field :resume_id, :string
    field :content, :string
    field :user_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(letter, attrs) do
    letter
    |> cast(attrs, [:job_description, :title, :resume_id, :user_id, :content])
    |> validate_required([:job_description, :title, :content])
  end

  def create(attrs) do
    validated = changeset(%CoverupBack.Letter{}, attrs)

    case validated do
      %Ecto.Changeset{valid?: true} ->
        Repo.insert!(validated)

      _ ->
        nil
    end
  end

  def get(id) do
    Repo.get(CoverupBack.Letter, id)
  end

  def get_by_user(user_id) do
    query = "SELECT * FROM letters WHERE user_id = $1"
    IO.puts("Here!")

    case Repo.query(query, [user_id]) do
      {:ok, %{rows: rows}} ->
        rows |> Enum.map(&convert_to_letter/1)

      _ ->
        nil
    end
  end

  def update(id, attrs) do
    letter = get(id)

    validated = changeset(letter, attrs)

    case validated do
      %Ecto.Changeset{valid?: true} ->
        Repo.update!(validated)

      _ ->
        nil
    end
  end

  def get_usuage(user_id) do
    query =
      "SELECT COUNT(*) FROM letters WHERE user_id = $1 AND inserted_at >= NOW() - INTERVAL '1 month'"

    case Repo.query(query, [user_id]) do
      {:ok, %{rows: [[count]]}} ->
        count

      _ ->
        nil
    end
  end

  def convert_to_letter(row) do
    %CoverupBack.Letter{
      id: Enum.at(row, 0),
      job_description: Enum.at(row, 1),
      title: Enum.at(row, 2),
      resume_id: Enum.at(row, 3),
      user_id: Enum.at(row, 4),
      inserted_at: Enum.at(row, 5),
      updated_at: Enum.at(row, 6),
      content: Enum.at(row, 7)
    }
  end

  def get_latest(user_id) do
    query = "SELECT * FROM letters WHERE user_id = $1 ORDER BY inserted_at DESC LIMIT 2"

    case Repo.query(query, [user_id]) do
      {:ok, %{rows: rows}} ->
        rows |> Enum.map(&convert_to_letter/1)

      _ ->
        nil
    end
  end

  def delete(id) do
    Repo.delete(CoverupBack.Letter, id)
  end
end
