defmodule Todoapp.Todolist do

  def get_max_todolistitem_id(user) do
    try do
      Enum.max(for item <- user.todolistitems, do: item.order_by)
    rescue
      Enum.EmptyError -> 0
    end
  end

end
