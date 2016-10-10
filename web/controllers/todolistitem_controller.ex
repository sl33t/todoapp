defmodule Todoapp.TodolistitemController do
  require Logger
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem


  def create(conn, %{"todolistitem" => todolistitem_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user = Repo.preload(current_user, :todolistitems)
    max_id = Repo.one(from(todolistitems in Todolistitem, select: max(todolistitems.order_by)))
    case max_id do
      nil ->
        max_id = 0
      num ->
        max_id = num
    end
    todolistitem_params = Map.put(todolistitem_params, "order_by", max_id + 1)
    changeset = current_user |> build_assoc(:todolistitems) |> Todolistitem.changeset(todolistitem_params)

    case Repo.insert(changeset) do
      {:ok, todolistitem} ->
        json(conn, %{
          id: todolistitem.id,
          text: todolistitem.text,
          flash_type: "info",
          flash_message: "Item created successfully.",
          state: true
        })
      {:error, changeset} ->
        json(conn, %{
          flash_type: "danger",
          flash_message: "Item failed to create.",
          state: false
        })
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

  def reorder(conn, %{"id_one" => id_one, "id_two" => id_two}) do
    todolistitem_one = Repo.get_by!(Todolistitem, order_by: id_one)
    swap = todolistitem_one.order_by
    todolistitem_two = Repo.get_by!(Todolistitem, order_by: id_two)
    todolistitem_one = Ecto.Changeset.change todolistitem_one, order_by: todolistitem_two.order_by
    todolistitem_two = Ecto.Changeset.change todolistitem_two, order_by: swap

    Repo.update!(todolistitem_one)
    Repo.update!(todolistitem_two)
    json(conn, %{flash_type: "info", flash_message: "Items reordered successfully.", state: true})
  end
end
