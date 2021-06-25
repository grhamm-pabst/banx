defmodule Banx.Accounts.CreateTest do
  use Banx.DataCase, async: true

  import Banx.Factory

  alias Banx.Accounts.Create

  describe "call/1" do
    test "when all params are valid, returns the account" do
      params = build(:account_params)

      response = Create.call(params)

      assert {:ok,
              %Banx.Account{
                current_balance: _balance,
                id: _id,
                inserted_at: _date,
                updated_at: _up_date
              }} = response
    end
  end
end
