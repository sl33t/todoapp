defmodule Todoapp.Web.UserView do
  use Todoapp.Web, :view

  def render("user.json", %{user: user}) do
    user
  end
end
