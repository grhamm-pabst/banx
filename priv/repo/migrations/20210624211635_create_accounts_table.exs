defmodule Banx.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :current_balance, :decimal
    end
  end
end
