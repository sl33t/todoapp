defmodule Todoapp.Todolistitem do
  use Todoapp.Web, :model

  alias Todoapp.User

  schema "todolistitems" do
    field :text, :string

    belongs_to :user, User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
