defmodule Todoapp.Web.Router do
  use Todoapp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated, handler: Todoapp.Web.AuthErrorController
  end

  scope "/api", Todoapp.Web do
    pipe_through [:api, :authenticated]

    get "/get", TodolistitemController, :get
    post "/create", TodolistitemController, :create
    put "/edit/:id", TodolistitemController, :update
    delete "/delete/:id", TodolistitemController, :delete
  end

  scope "/user", Todoapp.Web do
    pipe_through [:api, :authenticated]

    get "/get", UserController, :get
  end

  scope "/auth", Todoapp.Web do
    pipe_through :api

    post "/login", AuthController, :login
  end
end
