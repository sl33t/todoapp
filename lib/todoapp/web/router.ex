defmodule Todoapp.Web.Router do
  use Todoapp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Todoapp.Web do
    pipe_through :api

    get "/get", TodolistitemController, :get
    post "/create", TodolistitemController, :create
    put "/edit/:id", TodolistitemController, :update
    delete "/delete/:id", TodolistitemController, :delete
    post "/reorder", TodolistitemController, :reorder
  end

  scope "/auth", Todoapp.Web do
    pipe_through :api

    post "/logout", AuthController, :delete
    post "/login", AuthController, :login
  end
end
