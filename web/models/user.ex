defmodule Todoapp.User do
  use Todoapp.Web, :model

  alias Todoapp.Repo
  alias Todoapp.User
  alias Todoapp.Todolistitem

  schema "users" do
    field :name, :string
    field :oauth_id, :string
    field :avatar, :string
    field :email, :string

    has_many :todolistitems, Todolistitem

    timestamps()
  end

  alias Ueberauth.Auth

  def find_or_create(%Auth{} = auth) do
    info = basic_info(auth)

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

  defp basic_info(auth) do
    %{oauth_id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image, email: auth.info.email }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
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
