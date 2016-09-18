defmodule Todoapp.Todolistitem do
  use Todoapp.Web, :model

  schema "todolistitems" do
    field :text, :string
    field :header, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :header])
    |> validate_required([:text, :header])
  end
end
