defmodule Todoapp.PageController do
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem
  alias Todoapp.Repo

  def index(conn, _params) do
    conn |> render("index.html", [
      title: "Homepage",
      todo_list: Repo.all(Todolistitem),
      todo_list_changeset: Todolistitem.changeset(%Todolistitem{}),
      current_user: Guardian.Plug.current_resource(conn)
        ]
      )
  end
end
