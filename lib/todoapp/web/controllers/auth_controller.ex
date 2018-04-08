defmodule Todoapp.Web.AuthController do
  use Todoapp.Web, :controller

  alias Todoapp.Account

  def login(conn, %{"token" => token}) do
    {:ok, verified_user} = Account.verify_user(token)

    case Account.find_or_create(verified_user) do
      {:ok, user} ->
        { :ok, jwt, full_claims } = Guardian.encode_and_sign(user, :api)
        conn
        |> json(%{
          jwt: jwt,
          full_claims: full_claims,
          flash_type: "info",
          user: user
        })
      {:error, _reason} ->
        conn
        |> json(%{
          flash_type: "danger",
          flash_message: "Login failed"
        })
    end
  end
end
