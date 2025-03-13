defmodule CoverupBackWeb.Router do
  use CoverupBackWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoverupBackWeb do
    pipe_through :api

    get "/", HomeController, :index
    resources "/resumes", ResumeController
    resources "/letters", LetterController
    get "/resumes/user/:user_id", ResumeController, :show_by_user
    get "/letters/user/:user_id", LetterController, :index
    get "/letters/usuage/:user_id", LetterController, :usuage
    get "/dashboard/:user_id", LetterController, :dashboard
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:coverup_back, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CoverupBackWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
