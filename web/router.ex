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
  end

  scope "/todoitem", Todoapp do
    pipe_through(:browser)

    post "/create", TodolistitemController, :create
    get "/edit/:id", TodolistitemController, :edit
    put "/edit/:id", TodolistitemController, :update
    get "/delete/:id", TodolistitemController, :delete
  end
end
