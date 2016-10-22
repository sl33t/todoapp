defmodule Todoapp.PageControllerTest do
  use Todoapp.ConnCase

  def assert_contains(search_text, target) do
    assert String.contains?(search_text, target), ~s(Expected #{inspect search_text} to contain target)
  end

  test "ensure homepage loads and title is correct", %{conn: conn} do
    conn = get conn, "/"
    assert_contains html_response(conn, 200), "Homepage"
  end

end
