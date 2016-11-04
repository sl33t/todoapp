defmodule Todoapp.Todolistitem do
  use Todoapp.Web, :model

  alias Todoapp.User

  @derive {Poison.Encoder, only: [:text, :order_by]}
  schema "todolistitems" do
    field :text, :string
    field :order_by, :integer

    belongs_to :user, User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :order_by])
    |> validate_required([:text, :order_by])
  end
end
