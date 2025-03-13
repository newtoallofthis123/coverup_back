defmodule CoverupBackWeb.HomeController do
  use CoverupBackWeb, :controller

  def index(conn, _params) do
    json(conn, %{coverup: "v.0.1"})
  end
end
