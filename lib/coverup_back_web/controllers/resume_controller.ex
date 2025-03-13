defmodule CoverupBackWeb.ResumeController do
  use CoverupBackWeb, :controller
  alias CoverupBack.Resume

  def index(conn, {:user, user_id}) do
    resumes = Resume.get_by_user(user_id)

    json(conn, resumes)
  end

  def create(conn, %{"resume" => resume_params, "user_id" => user_id}) do
    resume = Resume.create(resume_params |> Map.put("user_id", user_id))

    json(conn, resume)
  end

  def show_by_user(conn, %{"user_id" => user_id}) do
    resume = Resume.get_by_user(user_id)

    case resume do
      nil ->
        conn
        |> put_status(404)
        |> json(%{error: "Resume not found"})

      _ ->
        json(conn, resume)
    end
  end

  def show(conn, %{"id" => id}) do
    resume = Resume.get(id)

    json(conn, resume)
  end

  def update(conn, %{"id" => id, "resume" => resume_params}) do
    resume = Resume.update(id, resume_params)

    json(conn, resume)
  end

  def delete(conn, %{"id" => id}) do
    resume = Resume.delete(id)

    json(conn, resume)
  end
end
