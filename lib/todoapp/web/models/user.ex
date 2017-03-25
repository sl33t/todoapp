defmodule Todoapp.Web.User do
  use Todoapp.Web, :model

  alias Todoapp.Web.Repo
  alias Todoapp.Web.User
  alias Todoapp.Web.Todolistitem

  @expected_fields ~w(
    azp aud sub email email_verified at_hash iss iat exp name picture given_name family_name locale alg kid
  )

  schema "users" do
    field :name, :string
    field :oauth_id, :string
    field :avatar, :string
    field :email, :string

    has_many :todolistitems, Todolistitem

    timestamps()
  end

  def verify_user(token) do

    case HTTPoison.get("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=" <> token) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

        body = body
        |> Poison.decode!
        |> Map.take(@expected_fields)
        |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)

        case System.get_env("GOOGLE_CLIENT_ID") == body[:aud] do
          true -> :ok
          false ->
            raise Todoapp.Web.Forbidden
        end
      {:ok, _} ->
        {:error, "Forbidden"}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(info) do
    case Repo.get_by(User, oauth_id: info.oauth_id) do
      nil ->
        new_user_changeset = User.changeset(%User{}, %{name: info.name, oauth_id: info.oauth_id, avatar: info.avatar, email: info.email})

        case Repo.insert(new_user_changeset) do
          {:ok, new_user} -> {:ok, new_user}
          {:error, error} -> {:error, error}
        end
      user -> {:ok, user}
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :oauth_id, :avatar, :email])
    |> validate_required([:name, :oauth_id, :avatar, :email])
  end
end
