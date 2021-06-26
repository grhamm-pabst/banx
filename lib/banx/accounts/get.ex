defmodule Banx.Accounts.Get do
  alias Banx.{Account, Repo}

  def by_id(id) do
    case retrieve_account(id) do
      nil -> {:error, "Account not found"}
      %Account{} = account -> {:ok, build_transactions(account)}
    end
  end

  defp retrieve_account(id) do
    Account
    |> Repo.get(id)
    |> Repo.preload([:sended, :received])
  end

  defp build_transactions(account) do
    transactions =
      (account.sended ++ account.received)
      |> Enum.sort(&(NaiveDateTime.compare(&1.when, &2.when) == :gt))

    Map.put(account, :transactions, transactions)
  end
end
