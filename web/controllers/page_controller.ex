defmodule Todoapp.PageController do
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem
  alias Todoapp.Repo

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    case current_user do
      nil ->
        conn |> render("landing.html", [
        title: "Homepage",
        current_user: nil
          ]
        )
      user ->
        user = Repo.preload(user, :todolistitems)
        conn |> render("index.html", [
        title: "Homepage",
        todo_list_changeset: Todolistitem.changeset(%Todolistitem{}),
        current_user: user
          ]
        )
    end

  end
end
