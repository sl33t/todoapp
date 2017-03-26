defmodule Todoapp.Todolist do

  alias Todoapp.Web.Repo
  alias Todoapp.Todolist.Todolistitem

  def add_new_todolist_item(user, params) do
    params = Map.put(params, "order_by", get_max_todolistitem_id(user) + 1)
    changeset = user |> Ecto.build_assoc(:todolistitems) |> Todolistitem.changeset(params)
    Repo.insert(changeset)
  end

  def update_todolist_item(user, id, params) do
    user
    |> Ecto.assoc(:todolistitems)
    |> Repo.get(id)
    |> Todolistitem.changeset(params)
    |> Repo.update
  end

  def delete_todolist_item(user, id) do
    user
    |> Ecto.assoc(:todolistitems)
    |> Repo.get(id)
    |> Repo.delete!
  end

  def get_max_todolistitem_id(user) do
    try do
      Enum.max(for item <- user.todolistitems, do: item.order_by)
    rescue
      Enum.EmptyError -> 0
    end
  end

end
