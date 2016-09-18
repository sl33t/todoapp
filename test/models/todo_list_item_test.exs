defmodule Todoapp.TodoListItemTest do
  use Todoapp.ModelCase

  alias Todoapp.TodoListItem

  @valid_attrs %{text: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TodoListItem.changeset(%TodoListItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TodoListItem.changeset(%TodoListItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
