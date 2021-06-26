defmodule Banx.Transactions.Create do
  alias Banx.{Account, Repo, Transaction}

  alias Ecto.{Changeset, Multi}

  def call(%{"sender_id" => sender_id, "amount" => amount, "address_id" => address_id} = params) do
    with %Changeset{valid?: true} = changeset <- Transaction.changeset(params),
         %{sender: sender, address: address} <-
           verify_disponility(sender_id, address_id, amount) do
      make_transaction(sender, address, amount, changeset)
    else
      false ->
        {:error, "Not enough money in sender's account"}

      nil ->
        {:error, "One of the accounts doesn't exists"}

      %Changeset{valid?: false} ->
        {:error, "Invalid Params"}
    end
  end

  defp verify_disponility(sender_id, address_id, amount) do
    with %Account{current_balance: balance} = sender <- Repo.get(Account, sender_id),
         %Account{} = address <- Repo.get(Account, address_id),
         true <- negative_balance_check(balance, amount) do
      %{sender: sender, address: address}
    end
  end

  defp negative_balance_check(balance, amount) do
    case Decimal.compare(balance, Decimal.new(amount)) do
      :gt -> true
      :eq -> true
      :lt -> false
    end
  end

  defp make_transaction(sender, address, amount, transaction) do
    sender =
      Changeset.change(sender,
        current_balance: Decimal.sub(sender.current_balance, Decimal.new(amount))
      )

    address =
      Changeset.change(address,
        current_balance: Decimal.add(address.current_balance, Decimal.new(amount))
      )

    {:ok, %{transaction_insert: transaction_inserted}} =
      Multi.new()
      |> Multi.update(:address_update, address)
      |> Multi.update(:sender_update, sender)
      |> Multi.insert(:transaction_insert, transaction)
      |> Repo.transaction()

    {:ok, transaction_inserted}
  end
end
