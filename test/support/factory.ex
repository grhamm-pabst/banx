defmodule Banx.Factory do
  use ExMachina.Ecto, repo: Banx.Repo

  alias Banx.{Account, Transaction}

  def account_factory do
    %Account{
      id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5c",
      current_balance: Decimal.new("10.10")
    }
  end

  def sender_factory do
    %Account{
      id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5c",
      current_balance: Decimal.new("10.10")
    }
  end

  def address_factory do
    %Account{
      id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d",
      current_balance: Decimal.new("10.10")
    }
  end

  def account_params_factory do
    %{
      "current_balance" => "10.10"
    }
  end

  def transaction_factory do
    %Transaction{
      id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5c",
      amount: Decimal.new("1.00"),
      sender_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5c",
      address_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d",
      when: ~N[2021-06-26 19:17:06]
    }
  end

  def transaction_params_factory do
    %{
      "amount" => "1.00",
      "sender_id" => "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5c",
      "address_id" => "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d"
    }
  end
end
