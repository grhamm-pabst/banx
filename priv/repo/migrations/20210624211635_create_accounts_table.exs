defmodule Banx.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :current_balance, :decimal

      timestamps()
    end
  end
end
