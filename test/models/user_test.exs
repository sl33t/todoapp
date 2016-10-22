defmodule Todoapp.UserTest do
  use Todoapp.ModelCase

  alias Todoapp.User

  @valid_attrs %{name: "Name", oauth_id: "1234", avatar: "Avatar", email: "Email"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
