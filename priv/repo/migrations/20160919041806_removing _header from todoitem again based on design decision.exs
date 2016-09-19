defmodule :"Elixir.Todoapp.Repo.Migrations.Removing Header from todoitem again based on design decision" do
  use Ecto.Migration

  def change do
    alter table(:todolistitems) do
      remove :header
    end
  end
end
