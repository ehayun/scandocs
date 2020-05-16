defmodule ScandocWeb.Router do
  use ScandocWeb, :router

  import ScandocWeb.UserAuth
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ScandocWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScandocWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  pipeline :admins_only do
    plug :basic_auth, username: "admin", password: "Vaadim68"
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScandocWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard", metrics: ScandocWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", ScandocWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/login", UserSessionController, :new
    post "/users/login", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ScandocWeb do
    pipe_through [:browser, :require_authenticated_user]

    delete "/users/logout", UserSessionController, :delete
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_zehut", UserSettingsController, :update_zehut
    get "/users/settings/confirm_zehut/:token", UserSettingsController, :confirm_zehut

    get "/documents/display/:id", DocumentController, :display

    live "/students", StudentLive.Index, :index
    live "/students/new", StudentLive.Index, :new
    live "/students/:id/edit", StudentLive.Index, :edit

    live "/students/:id", StudentLive.Show, :show
    live "/students/:id/show/edit", StudentLive.Show, :edit

    # Student document

    live "/stddocs", StddocLive.Index, :index
    live "/stddocs/new", StddocLive.Index, :new
    live "/stddocs/:id/edit", StddocLive.Index, :edit

    live "/stddocs/:id", StddocLive.Show, :show
    live "/stddocs/:id/show/edit", StddocLive.Show, :edit

    # Institutes
    live "/institutes", InstituteLive.Index, :index
    live "/institutes/new", InstituteLive.Index, :new
    live "/institutes/:id/edit", InstituteLive.Index, :edit

    live "/institutes/:id", InstituteLive.Show, :show
    live "/institutes/:id/show/edit", InstituteLive.Show, :edit

    # Cagegories
    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Index, :new
    live "/categories/:id/edit", CategoryLive.Index, :edit

    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/show/edit", CategoryLive.Show, :edit

    # outcome category
    live "/outcome_categoryes", OutcomeCategoryLive.Index, :index
    live "/outcome_categoryes/new", OutcomeCategoryLive.Index, :new
    live "/outcome_categoryes/:id/edit", OutcomeCategoryLive.Index, :edit

    live "/outcome_categoryes/:id", OutcomeCategoryLive.Show, :show
    live "/outcome_categoryes/:id/show/edit", OutcomeCategoryLive.Show, :edit

    # Vendors
    live "/vendors", VendorLive.Index, :index
    live "/vendors/new", VendorLive.Index, :new
    live "/vendors/:id/edit", VendorLive.Index, :edit

    live "/vendors/:id", VendorLive.Show, :show
    live "/vendors/:id/show/edit", VendorLive.Show, :edit

    # Vendor coduments
    live "/inst_docs", InstdocLive.Index, :index
    live "/inst_docs/new", InstdocLive.Index, :new
    live "/inst_docs/:id/edit", InstdocLive.Index, :edit

    live "/inst_docs/:id", InstdocLive.Show, :show
    live "/inst_docs/:id/show/edit", InstdocLive.Show, :edit

    resources "/schools", SchoolController
    resources "/managers", ManagerController
    resources "/teachers", TeacherController
    resources "/classrooms", ClassroomController
    resources "/documents", DocumentController
    get "/docdownload/:id", DocumentController, :doc_download
  end

  scope "/", ScandocWeb do
    pipe_through [:browser, :require_admin_user]

    get "/users/loginas/:id", UserSessionController, :loginas

    # Permissions
    live "/permissions", PermissionLive.Index, :index
    live "/permissions/new", PermissionLive.Index, :new
    live "/permissions/:id/edit", PermissionLive.Index, :edit

    live "/permissions/:id", PermissionLive.Show, :show
    live "/permissions/:id/show/edit", PermissionLive.Show, :edit

    live "/docgroups", DocgroupLive.Index, :index
    live "/docgroups/new", DocgroupLive.Index, :new
    live "/docgroups/:id/edit", DocgroupLive.Index, :edit

    live "/docgroups/:id", DocgroupLive.Show, :show
    live "/docgroups/:id/show/edit", DocgroupLive.Show, :edit
  end

  scope "/", ScandocWeb do
    pipe_through [:browser]

    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
