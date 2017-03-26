defmodule Todoapp.Web.AuthController do
  use Todoapp.Web, :controller

  alias Todoapp.Account

  def login(conn, %{"user" => user_params}) do
    user_params = for {key, val} <- user_params, into: %{}, do: {String.to_atom(key), val}

    Account.verify_user(user_params.token)

    case Account.find_or_create(user_params) do
      {:ok, user} ->
        { :ok, jwt, full_claims } = Guardian.encode_and_sign(user, :api)
        conn
        |> json(%{
          jwt: jwt,
          full_claims: full_claims,
          flash_type: "info",
          flash_message: user.name <> " has been logged in."
        })
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> json(%{
          flash_type: "danger",
          flash_message: "Login failed"
        })
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> json(%{
      flash_type: "info",
      flash_message: "You have been logged out."
    })
  end
end
