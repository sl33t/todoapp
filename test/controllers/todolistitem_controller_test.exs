defmodule Todoapp.TodolistitemControllerTest do
  use Todoapp.ConnCase

  alias Todoapp.Todolistitem
  @valid_attrs %{text: "some content"}
  @invalid_attrs %{}

  def assert_contains(search_text, target) do
    assert String.contains?(search_text, target), ~s(Expected #{inspect search_text} to contain target)
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, todolistitem_path(conn, :create), todolistitem: @valid_attrs
    assert redirected_to(conn) == todolistitem_path(conn, :index)
    assert Repo.get_by(Todolistitem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todolistitem_path(conn, :create), todolistitem: @invalid_attrs
    assert html_response(conn, 200) =~ "New todolistitem"
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
    assert html_response(conn, 200) =~ "Edit todolistitem"
  end

  test "deletes chosen resource", %{conn: conn} do
    todolistitem = Repo.insert! %Todolistitem{}
    conn = delete conn, todolistitem_path(conn, :delete, todolistitem)
    assert redirected_to(conn) == todolistitem_path(conn, :index)
    refute Repo.get(Todolistitem, todolistitem.id)
  end
end
