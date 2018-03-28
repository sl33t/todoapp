defmodule Todoapp.Account.User do
  use Todoapp.Web, :model

  alias Todoapp.Todolist.Todolistitem

  @derive {Poison.Encoder, only: [:name, :oauth_id, :avatar, :email]}
  schema "users" do
    field :name, :string
    field :oauth_id, :string
    field :avatar, :string
    field :email, :string

    has_many :todolistitems, Todolistitem

    timestamps()
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
