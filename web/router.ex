defmodule Todoapp.Router do
  use Todoapp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Todoapp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Todoapp do
    pipe_through :browser

    post "/create", TodolistitemController, :create
    put "/edit/:id", TodolistitemController, :update
    delete "/delete/:id", TodolistitemController, :delete
    get "/reorder/:id_one/:id_two", TodolistitemController, :reorder
  end

  scope "/auth", Todoapp do
    pipe_through :browser

    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
