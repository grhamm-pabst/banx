defmodule Banx.Transactions.CreateTest do
  use Banx.DataCase, async: true

  import Banx.Factory

  alias Banx.Transactions.Create

  describe "call/1" do
    test "when all params are valid, returns the created transaction and transfer money" do
      insert(:sender)
      insert(:address)

      params = build(:transaction_params)

      response = Create.call(params)

      assert {:ok,
              %Banx.Transaction{
                address_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d",
                amount: _amount,
                id: _id,
                inserted_at: _date,
                sender_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5c",
                updated_at: _up_date,
                when: _when
              }} = response
    end

    test "when the sender don't have enough money, returns an error" do
      insert(:sender, current_balance: "0")
      insert(:address)

      params = build(:transaction_params)

      response = Create.call(params)

      expected_response = {:error, "Not enough money in sender's account"}

      assert expected_response == response
    end

    test "when one of the accounts doesn't exist, returns an error" do
      params = build(:transaction_params)

      response = Create.call(params)

      expected_response = {:error, "One of the accounts doesn't exists"}

      assert expected_response == response
    end

    test "when there are invalid params, returns an error" do
      params = build(:transaction_params, %{amount: "-1"})

      {:error, response} = Create.call(params)

      expected_response = %{amount: ["must be greater than 0"]}

      assert expected_response == errors_on(response)
    end
  end
end
