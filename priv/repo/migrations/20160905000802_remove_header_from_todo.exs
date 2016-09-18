defmodule Todoapp.Repo.Migrations.RemoveHeaderFromTodo do
    use Ecto.Migration

    def change do
      alter table(:todolistitems) do
        remove :header
      end
    end
  end
