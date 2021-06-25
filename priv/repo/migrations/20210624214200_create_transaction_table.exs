defmodule Banx.Repo.Migrations.CreateTransactionTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :sender_id, references(:accounts)
      add :address_id, references(:accounts)
      add :amount, :decimal
      add :when, :naive_datetime

      timestamps()
    end
  end
end
