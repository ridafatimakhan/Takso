defmodule TaksoWeb.Router do
  use TaksoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TaksoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Takso.Authentication, repo: Takso.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaksoWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/users", UserController
    resources "/bookings", BookingController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaksoWeb domix phx.server
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:takso, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaksoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

# defmodule TaksoWeb.Router.Helpers do
#   use Phoenix.HTML, :quote
#   def user_path(_conn, :show, _user) do
#     quote do
#       Routes.user_path(:show, user)
#     end
#   end
# #   @spec user_path(any(), :show, any()) ::
# #           {{:., [{any(), any()}, ...], [:user_path | {any(), any(), any()}, ...]},
# #            [{:closing, [...]} | {:column, 14}, ...],
# #            [:show | {:user, [...], TaksoWeb.Router.Helpers}, ...]}
# # end
