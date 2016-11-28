defmodule Todoapp.AuthController do
  use Todoapp.Web, :controller

  alias Todoapp.User

  def login(conn, %{"user" => user_params}) do
    case User.find_or_create(user_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def delete(conn, %{"user" => user_params}) do
    Guardian.Plug.sign_out(conn)
    |> redirect(to: "/")
  end
end
