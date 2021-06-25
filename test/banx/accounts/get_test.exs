defmodule Banx.Accounts.GetTest do
  use Banx.DataCase, async: true

  import Banx.Factory

  alias Banx.Account

  alias Banx.Accounts.Get

  describe "by_id/1" do
    test "when the account exists, returns the account" do
      %Account{id: id} = insert(:account)

      response = Get.by_id(id)

      assert {:ok,
              %Banx.Account{
                current_balance: _balance,
                id: _id,
                inserted_at: _date,
                updated_at: _up_date
              }} = response
    end

    test "when there's no account with the given id, returns an error" do
      %Account{id: id} = build(:account)

      response = Get.by_id(id)

      expected_response = {:error, "Account not found"}

      assert expected_response == response
    end
  end
end
