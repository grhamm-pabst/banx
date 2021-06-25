defmodule Banx.Accounts.Create do
  alias Banx.{Account, Repo}

  alias Ecto.Changeset

  def call(params) do
    with %Changeset{valid?: true} = account <- Account.changeset(params) do
      Repo.insert(account)
    else
      changeset -> {:error, changeset}
    end
  end
end
