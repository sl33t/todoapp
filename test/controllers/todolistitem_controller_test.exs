defmodule Todoapp.Web.TodolistitemControllerTest do
  use Todoapp.Web.ConnCase

  alias Todoapp.Todolist.Todolistitem
  alias Todoapp.Account.User
  alias Todoapp.Web.Repo
  @valid_attrs %{text: "some content"}
  @valid_attrs2 %{text: "some content2"}
  @invalid_attrs %{text: nil}

  def assert_contains(search_text, target) do
    assert String.contains?(search_text, target), ~s(Expected #{inspect search_text} to contain #{inspect target})
  end

  def guardian_login(user) do
    {:ok, jwt, _full_claims} =Guardian.encode_and_sign(user, :api)

    build_conn()
    |> put_req_header("authorization", jwt)
  end

  setup do
    Repo.insert!(%User{name: "name", oauth_id: "id", avatar: "avatar", email: "email@email.com"})
    Repo.insert!(%User{name: "name2", oauth_id: "id2", avatar: "avatar2", email: "email2@email.com"})
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
    guardian_login(user)
    |> delete(todolistitem_path(conn, :delete, todolistitem))
    refute Repo.get(Todolistitem, todolistitem.id)
  end
end
