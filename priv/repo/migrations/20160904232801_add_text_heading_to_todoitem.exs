defmodule Todoapp.Repo.Migrations.AddTextHeadingToTodoitem do
  use Ecto.Migration

  def change do
    alter table(:todolistitems) do
      add :header, :string
    end
  end
end
