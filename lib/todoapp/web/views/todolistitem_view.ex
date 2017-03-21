defmodule Todoapp.Web.TodolistitemView do
  use Todoapp.Web, :view

  def render("get.json", %{todolistitems: todolistitems}) do
    todolistitems
  end
end
