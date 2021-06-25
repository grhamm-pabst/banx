defmodule Banx.TransactionTest do
  use Banx.DataCase, async: true

  alias Banx.{Account, Transaction}
  alias Banx.Accounts.Create

  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        amount: Decimal.new("1.00"),
        sender_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d",
        address_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5f"
      }

      response = Transaction.changeset(params)

      assert %Changeset{valid?: true} = response
    end

    test "when the amount is lower than 0, returns an error" do
      params = %{
        amount: Decimal.new("-1.00"),
        sender_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d",
        address_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5f"
      }

      response = Transaction.changeset(params)

      expected_response = %{amount: ["must be greater than or equal to 0"]}

      assert errors_on(response) == expected_response
    end

    test "when the sender is the same as the address, returns an error" do
      params = %{
        amount: Decimal.new("1.00"),
        sender_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d",
        address_id: "9c0ae6cc-a7d6-4367-b72c-5491f0fdae5d"
      }

      response = Transaction.changeset(params)

      expected_response = %{
        sender_id: ["Sender should not be the same as the Address"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
