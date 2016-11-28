defmodule Todoapp.Router do
  use Todoapp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Todoapp do
    pipe_through :api

    get "/get", TodolistitemController, :get
    post "/create", TodolistitemController, :create
    put "/edit/:id", TodolistitemController, :update
    delete "/delete/:id", TodolistitemController, :delete
    post "/reorder", TodolistitemController, :reorder
  end

  scope "/auth", Todoapp do
    pipe_through :api

    post "/logout", AuthController, :delete
    post "/login", AuthController, :login
  end
end
