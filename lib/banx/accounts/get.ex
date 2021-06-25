defmodule Banx.Accounts.Get do
  alias Banx.{Account, Repo}

  def by_id(id) do
    case Repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      %Account{} = account -> {:ok, account}
    end
  end
end
