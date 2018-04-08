defmodule Todoapp.Web.UserController do
  require Logger
  use Todoapp.Web, :controller

  alias Todoapp.Account

  def get(conn, _params) do
    current_user = conn
    |> Account.get_current_user()

    render conn, "user.json", user: current_user
  end
end
