defmodule Todoapp.TodolistitemController do
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem


  def create(conn, %{"todolistitem" => todolistitem_params}) do
    changeset = Todolistitem.changeset(%Todolistitem{}, todolistitem_params)

    case Repo.insert(changeset) do
      {:ok, _todolistitem} ->
        conn
        |> put_flash(:info, "Todolistitem created successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Todolistitem failed to create")
        |> redirect(to: "/")
    end
  end

  def edit(conn, %{"id" => id}) do
    todolistitem = Repo.get!(Todolistitem, id)
    changeset = Todolistitem.changeset(todolistitem)
    render(conn, "edit.html", [todolistitem: todolistitem, changeset: changeset, title: "Add new TodoListItems"])
  end

  def update(conn, %{"id" => id, "todolistitem" => todolistitem_params}) do
    todolistitem = Repo.get!(Todolistitem, id)
    changeset = Todolistitem.changeset(todolistitem, todolistitem_params)

    case Repo.update(changeset) do
      {:ok, todolistitem} ->
        conn
        |> put_flash(:info, "Todolistitem updated successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "edit.html", [todolistitem: todolistitem, changeset: changeset, title: "Add new TodoListItems"])
    end
  end

  def delete(conn, %{"id" => id}) do
    todolistitem = Repo.get!(Todolistitem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todolistitem)

    conn
    |> put_flash(:info, "Todolistitem deleted successfully.")
    |> redirect(to: "/")
  end
end
