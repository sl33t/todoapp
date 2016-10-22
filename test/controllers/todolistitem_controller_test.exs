defmodule Todoapp.TodolistitemControllerTest do
  use Todoapp.ConnCase

  alias Todoapp.Todolistitem
  alias Todoapp.User
  alias Todoapp.Repo
  @valid_attrs %{text: "some content"}
  @invalid_attrs %{}

  def assert_contains(search_text, target) do
    assert String.contains?(search_text, target), ~s(Expected #{inspect search_text} to contain target)
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
    user = Repo.insert!(%User{name: "name", oauth_id: "id", avatar: "avatar", email: "email@email.com"})
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

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    todolistitem = Repo.insert! %Todolistitem{}
    conn = put conn, todolistitem_path(conn, :update, todolistitem), todolistitem: @valid_attrs
    assert redirected_to(conn) == todolistitem_path(conn, :show, todolistitem)
    assert Repo.get_by(Todolistitem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    todolistitem = Repo.insert! %Todolistitem{}
    conn = put conn, todolistitem_path(conn, :update, todolistitem), todolistitem: @invalid_attrs
    assert_contains html_response(conn, 200), "Item failed to update."
  end

  test "deletes chosen resource", %{conn: conn} do
    todolistitem = Repo.insert! %Todolistitem{}
    conn = delete conn, todolistitem_path(conn, :delete, todolistitem)
    assert redirected_to(conn) == todolistitem_path(conn, :index)
    refute Repo.get(Todolistitem, todolistitem.id)
  end
end
