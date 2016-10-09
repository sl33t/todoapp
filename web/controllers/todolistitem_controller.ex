defmodule Todoapp.TodolistitemController do
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem


  def create(conn, %{"todolistitem" => todolistitem_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user = Repo.preload(current_user, :todolistitems)
    changeset = current_user |> build_assoc(:todolistitems) |> Todolistitem.changeset(todolistitem_params)

    case Repo.insert(changeset) do
      {:ok, todolistitem} ->
        json(conn, %{id: todolistitem.id, text: todolistitem.text, flash_type: "info", flash_message: "Item created successfully.", state: true})
      {:error, changeset} ->
        IO.puts(changeset)
        json(conn, %{flash_type: "danger", flash_message: "Item failed to create.", state: false})
    end
  end

  def update(conn, %{"id" => id, "todolistitem" => todolistitem_params}) do
    todolistitem = Repo.get!(Todolistitem, id)
    changeset = Todolistitem.changeset(todolistitem, todolistitem_params)

    case Repo.update(changeset) do
      {:ok, _todolistitem} ->
        json(conn, %{flash_type: "info", flash_message: "Item updated successfully.", state: true})
      {:error, _changeset} ->
        json(conn, %{flash_type: "danger", flash_message: "Item failed to update.", state: false})
    end
  end

  def delete(conn, %{"id" => id}) do
    todolistitem = Repo.get!(Todolistitem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todolistitem)

    json(conn, %{flash_type: "info", flash_message: "Item deleted successfully.", state: true})
  end
end
