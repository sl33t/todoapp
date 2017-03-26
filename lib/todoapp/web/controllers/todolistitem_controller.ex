defmodule Todoapp.Web.TodolistitemController do
  require Logger
  use Todoapp.Web, :controller

  alias Todoapp.Account
  alias Todoapp.Todolist

  def get(conn, _params) do
    current_user = conn
    |> Account.get_current_user_preloaded()

    render conn, "get.json", todolistitems: current_user.todolistitems
  end

  def create(conn, %{"todolistitem" => todolistitem_params}) do
    current_user = conn
    |> Account.get_current_user_preloaded()

    case Todolist.add_new_todolist_item(current_user, todolistitem_params) do
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
    user = conn
    |> Account.get_current_user

    case Todolist.update_todolist_item(user, id, todolistitem_params) do
      {:ok, _todolistitem} ->
        json(conn, %{flash_type: "info", flash_message: "Item updated successfully.", state: true})
      {:error, _changeset} ->
        json(conn, %{flash_type: "danger", flash_message: "Item failed to update.", state: false})
    end
  end

  def delete(conn, %{"id" => id}) do
    conn
    |> Account.get_current_user
    |> Todolist.delete_todolist_item(id)

    json(conn, %{flash_type: "info", flash_message: "Item deleted successfully.", state: true})
  end
end
