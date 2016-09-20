defmodule Todoapp.TodolistitemController do
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem


  def create(conn, %{"todolistitem" => todolistitem_params}) do
    changeset = Todolistitem.changeset(%Todolistitem{}, todolistitem_params)

    case Repo.insert(changeset) do
      {:ok, _todolistitem} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: "/")
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Item failed to create")
        |> redirect(to: "/")
    end
  end

  def edit(conn, %{"id" => id}) do
    todolistitem = Repo.get!(Todolistitem, id)
    changeset = Todolistitem.changeset(todolistitem)
    render(conn, "edit.html", [todolistitem: todolistitem, changeset: changeset, title: "Edit"])
  end

  def update(conn, %{"id" => id, "todolistitem" => todolistitem_params}) do
    todolistitem = Repo.get!(Todolistitem, id)
    changeset = Todolistitem.changeset(todolistitem, todolistitem_params)

    case Repo.update(changeset) do
      {:ok, _todolistitem} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Item failed to update.")
    end
  end

  def delete(conn, %{"id" => id}) do
    todolistitem = Repo.get!(Todolistitem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todolistitem)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: "/")
  end
end
