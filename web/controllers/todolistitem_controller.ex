defmodule Todoapp.TodolistitemController do
  require Logger
  use Todoapp.Web, :controller

  alias Todoapp.Todolistitem


  def create(conn, %{"todolistitem" => todolistitem_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user = Repo.preload(current_user, :todolistitems)
    max_id = Repo.one(from(todolistitems in Todolistitem, select: max(todolistitems.order_by)))
    max_id =
      case max_id do
        nil ->
          0
        num ->
          num
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
      {:error, _changeset} ->
        json(conn, %{
          flash_type: "danger",
          flash_message: "Item failed to create.",
          state: false
        })
    end
  end

  def update(conn, %{"id" => id, "todolistitem" => todolistitem_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user = Repo.preload(current_user, todolistitems: from(todolistitem in Todolistitem, where: todolistitem.id == ^id))
    todolistitem = List.first(current_user.todolistitems)
    changeset = Todolistitem.changeset(todolistitem, todolistitem_params)

    case Repo.update(changeset) do
      {:ok, _todolistitem} ->
        json(conn, %{flash_type: "info", flash_message: "Item updated successfully.", state: true})
      {:error, _changeset} ->
        json(conn, %{flash_type: "danger", flash_message: "Item failed to update.", state: false})
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    current_user = Repo.preload(current_user, todolistitems: from(todolistitem in Todolistitem, where: todolistitem.id == ^id))
    todolistitem = List.first(current_user.todolistitems)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(todolistitem)

    json(conn, %{flash_type: "info", flash_message: "Item deleted successfully.", state: true})
  end

  def reorder(conn, %{"serializedListOfTodoItems" => serializedListOfTodoItems}) do
    current_user = Guardian.Plug.current_resource(conn)
    Enum.reduce(serializedListOfTodoItems, 0, fn(item, count) ->
      from(todoitem in assoc(current_user, :todolistitems), where: todoitem.id == ^item, update: [set: [order_by: ^count]]) |> Repo.update_all([])
      count + 1
    end)
    json(conn, %{flash_type: "info", flash_message: "List order has been updated.", state: true})
  end
end
