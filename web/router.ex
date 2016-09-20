defmodule Todoapp.Router do
  use Todoapp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Todoapp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/create", TodolistitemController, :create
    put "/edit/:id", TodolistitemController, :update
    get "/delete/:id", TodolistitemController, :delete
  end

  scope "/auth", Todoapp do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
