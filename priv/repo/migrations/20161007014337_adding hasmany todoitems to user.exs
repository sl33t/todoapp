defmodule :"Elixir.Todoapp.Repo.Migrations.Adding hasmany todoitems to user" do
  use Ecto.Migration

  def change do
    alter table(:todolistitems) do
      add :user_id, :integer
    end
  end
end
