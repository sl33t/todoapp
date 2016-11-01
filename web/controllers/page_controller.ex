defmodule Todoapp.PageController do
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem
  alias Todoapp.Repo

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    case current_user do
      nil ->
        conn |> render("landing.html", [
        current_user: nil
          ]
        )
      user ->
        user = Repo.preload(user, todolistitems: from(todolistitems in Todolistitem, order_by: :order_by))
        conn |> render("index.html", [
        todo_list_changeset: Todolistitem.changeset(%Todolistitem{}),
        current_user: user
          ]
        )
    end

  end
end
