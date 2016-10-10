defmodule :"Elixir.Todoapp.Repo.Migrations.Order by field in todolistitem" do
  use Ecto.Migration

  def change do
    alter table(:todolistitems) do
      add :order_by, :integer
    end
  end
end
