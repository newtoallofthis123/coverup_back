defmodule CoverupBackWeb.LetterController do
  use CoverupBackWeb, :controller

  alias CoverupBack.Letter
  alias CoverupBack.Gen
  alias CoverupBack.Resume

  def index(conn, %{"user_id" => user_id}) do
    letters = Letter.get_by_user(user_id)
    json(conn, letters)
  end

  def create(conn, %{"letter" => letter_params, "user_id" => user_id}) do
    # if title or job_description not in letter_params, reject
    if not Map.has_key?(letter_params, "title") or
         not Map.has_key?(letter_params, "job_description") do
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{error: "Missing required fields"})
    end

    resume = Resume.get_by_user(user_id)

    if resume == nil do
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{error: "No resume found for user"})
    end

    case Jason.encode(resume) do
      {:ok, resume_json} ->
        case Gen.generate_response(resume_json, letter_params["job_description"]) do
          {:ok, content} ->
            IO.puts(content)

            letter_params =
              letter_params
              |> Map.put("content", content)
              |> Map.put("resume_id", resume.id |> Integer.to_string())
              |> Map.put("user_id", user_id)

            letter =
              Letter.create(letter_params)

            case letter do
              %CoverupBack.Letter{} = letter ->
                conn
                |> put_status(:created)
                |> json(%{letter: letter})

              nil ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{error: "Failed to create letter"})
            end

          {:error, error} ->
            conn |> put_status(:unprocessable_entity) |> json(%{error: error})
        end

      {:error, _} ->
        conn |> put_status(:unprocessable_entity) |> json(%{error: "Invalid JSON"})
    end
  end

  def show(conn, %{"id" => id}) do
    letter = Letter.get(id)

    json(conn, letter)
  end

  def usuage(conn, %{"user_id" => user_id}) do
    case Letter.get_usuage(user_id) do
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "No usuage found"})

      count ->
        conn
        |> put_status(:ok)
        |> json(%{count: count})
    end
  end

  def dashboard(conn, %{"user_id" => user_id}) do
    resume = Resume.get_by_user(user_id)
    has_resume = if resume != nil, do: true, else: false

    case Letter.get_latest(user_id) do
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "No latest letter found"})

      letters ->
        count = Letter.get_usuage(user_id)

        if count != nil do
          conn
          |> put_status(:ok)
          |> json(%{letters: letters, count: count, has_resume: has_resume})
        end
    end
  end

  def update(conn, params) do
    letter_params = params["letter"]
    letter = Letter.update(params["id"], letter_params)

    json(conn, letter)
  end

  def delete(conn, %{"id" => id}) do
    letter = Letter.delete(id)

    json(conn, letter)
  end
end
