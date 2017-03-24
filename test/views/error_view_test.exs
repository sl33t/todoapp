defmodule Todoapp.Web.ErrorViewTest do
  use Todoapp.Web.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  def assert_contains(search_text, target) do
    assert String.contains?(search_text, target), ~s(Expected #{inspect search_text} to contain #{inspect target})
  end

  test "renders 405.json" do
    assert_contains render_to_string(Todoapp.Web.ErrorView, "405.json", []), "You do not have access to this resource."
  end

  test "render 500.html" do
    assert render_to_string(Todoapp.Web.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(Todoapp.Web.ErrorView, "505.html", []) ==
           "Internal server error"
  end
end
