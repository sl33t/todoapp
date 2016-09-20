defmodule Todoapp.User do
  use Todoapp.Web, :model

  schema "users" do
    field :name, :string
    field :password, :string

    timestamps()
  end

  def find_or_create(auth) do
    {:ok, "hey"}
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
  end
end
