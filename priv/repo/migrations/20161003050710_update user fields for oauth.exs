defmodule :"Elixir.Todoapp.Repo.Migrations.Update user fields for oauth" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :oauth_id, :string
      add :avatar, :string
      add :email, :string
      remove :password
    end
  end
end
