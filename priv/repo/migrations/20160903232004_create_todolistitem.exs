defmodule Todoapp.Repo.Migrations.CreateTodolistitem do
  use Ecto.Migration

  def change do
    create table(:todolistitems) do
      add :text, :string

      timestamps()
    end

  end
end
