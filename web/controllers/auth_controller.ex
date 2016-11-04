defmodule Todoapp.AuthController do
  use Todoapp.Web, :controller
  plug Ueberauth

  alias Todoapp.User

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.find_or_create(auth) do
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

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> redirect(to: "/")
  end
end
