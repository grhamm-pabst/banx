defmodule Banx.Repo.Migrations.CreateTransactionTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :sender, references(:accounts)
      add :address, references(:accounts)
      add :amount, :decimal
      add :when, :date
    end
  end
end
