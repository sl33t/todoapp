defmodule Todoapp.TodolistitemTest do
  use Todoapp.ModelCase

  alias Todoapp.Todolistitem

  @valid_attrs %{text: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Todolistitem.changeset(%Todolistitem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Todolistitem.changeset(%Todolistitem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
