defmodule Todoapp.TodoListItemControllerTest do
  use Todoapp.ConnCase

  alias Todoapp.TodoListItem
  @valid_attrs %{text: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, todo_list_item_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing todolistitems"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, todo_list_item_path(conn, :new)
    assert html_response(conn, 200) =~ "New todo list item"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, todo_list_item_path(conn, :create), todo_list_item: @valid_attrs
    assert redirected_to(conn) == todo_list_item_path(conn, :index)
    assert Repo.get_by(TodoListItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, todo_list_item_path(conn, :create), todo_list_item: @invalid_attrs
    assert html_response(conn, 200) =~ "New todo list item"
  end

  test "shows chosen resource", %{conn: conn} do
    todo_list_item = Repo.insert! %TodoListItem{}
    conn = get conn, todo_list_item_path(conn, :show, todo_list_item)
    assert html_response(conn, 200) =~ "Show todo list item"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, todo_list_item_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    todo_list_item = Repo.insert! %TodoListItem{}
    conn = get conn, todo_list_item_path(conn, :edit, todo_list_item)
    assert html_response(conn, 200) =~ "Edit todo list item"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    todo_list_item = Repo.insert! %TodoListItem{}
    conn = put conn, todo_list_item_path(conn, :update, todo_list_item), todo_list_item: @valid_attrs
    assert redirected_to(conn) == todo_list_item_path(conn, :show, todo_list_item)
    assert Repo.get_by(TodoListItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    todo_list_item = Repo.insert! %TodoListItem{}
    conn = put conn, todo_list_item_path(conn, :update, todo_list_item), todo_list_item: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit todo list item"
  end

  test "deletes chosen resource", %{conn: conn} do
    todo_list_item = Repo.insert! %TodoListItem{}
    conn = delete conn, todo_list_item_path(conn, :delete, todo_list_item)
    assert redirected_to(conn) == todo_list_item_path(conn, :index)
    refute Repo.get(TodoListItem, todo_list_item.id)
  end
end
