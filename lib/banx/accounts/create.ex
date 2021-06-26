defmodule Banx.Accounts.Create do
  alias Banx.{Account, Repo}

  alias Ecto.Changeset

  def call(params) do
    case Account.changeset(params) do
      %Changeset{valid?: true} = account -> Repo.insert(account)
      changeset -> {:error, changeset}
    end
  end
end
