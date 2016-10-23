defmodule Todoapp.TodolistitemControllerTest do
  use Todoapp.ConnCase

  alias Todoapp.Todolistitem
  alias Todoapp.User
  alias Todoapp.Repo
  @valid_attrs %{text: "some content"}
  @valid_attrs2 %{text: "some content2"}
  @invalid_attrs %{text: nil}

  def assert_contains(search_text, target) do
    assert String.contains?(search_text, target), ~s(Expected #{inspect search_text} to contain #{inspect target})
  end

  def guardian_login(user, token \\ :token, opts \\ []) do
    build_conn()
      |> bypass_through(Todoapp.Router, [:browser])
      |> get("/")
      |> Guardian.Plug.sign_in(user, token, opts)
      |> send_resp(200, "Flush the session yo")
      |> recycle()
  end

  setup do
    Repo.insert!(%User{name: "name", oauth_id: "id", avatar: "avatar", email: "email@email.com"})
    :ok
  end

  test "creates resource", %{conn: conn} do
    user = Repo.get_by(User, name: "name")
    conn = guardian_login(user)
    |> post(todolistitem_path(conn, :create), todolistitem: @valid_attrs)
    assert_contains json_response(conn, 200)["flash_message"], "Item created successfully."
    assert Repo.get_by(Todolistitem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.get_by(User, name: "name")
    conn = guardian_login(user)
    |> post(todolistitem_path(conn, :create), todolistitem: @invalid_attrs)
    assert_contains json_response(conn, 200)["flash_message"], "Item failed to create."
  end

  test "updates chosen resource and success", %{conn: conn} do
    user = Repo.get_by(User, name: "name")
    conn = guardian_login(user)
    |> post(todolistitem_path(conn, :create), todolistitem: @valid_attrs)

    user = Repo.preload(user, todolistitems: from(todolistitem in Todolistitem))
    todolistitem = List.first(user.todolistitems)
    conn = guardian_login(user)
    |> put(todolistitem_path(conn, :update, todolistitem), todolistitem: @valid_attrs2)
    assert Repo.get_by(Todolistitem, @valid_attrs2)
    assert_contains json_response(conn, 200)["flash_message"], "Item updated successfully."
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.get_by(User, name: "name")
    conn = guardian_login(user)
    |> post(todolistitem_path(conn, :create), todolistitem: @valid_attrs)

    user = Repo.preload(user, todolistitems: from(todolistitem in Todolistitem))
    todolistitem = List.first(user.todolistitems)
    conn = guardian_login(user)
    |> put(todolistitem_path(conn, :update, todolistitem), todolistitem: @invalid_attrs)
    assert_contains json_response(conn, 200)["flash_message"], "Item failed to update."
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.get_by(User, name: "name")
    conn = guardian_login(user)
    |> post(todolistitem_path(conn, :create), todolistitem: @valid_attrs)

    user = Repo.preload(user, todolistitems: from(todolistitem in Todolistitem))
    todolistitem = List.first(user.todolistitems)
    conn = guardian_login(user)
    |> delete(todolistitem_path(conn, :delete, todolistitem))
    refute Repo.get(Todolistitem, todolistitem.id)
  end
end
