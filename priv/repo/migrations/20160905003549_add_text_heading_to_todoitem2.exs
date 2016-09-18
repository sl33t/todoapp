defmodule Todoapp.Repo.Migrations.AddTextHeadingToTodoitem2 do
  use Ecto.Migration

  def change do
    alter table(:todolistitems) do
      add :header, :string
    end
  end
end
