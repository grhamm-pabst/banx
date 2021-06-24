defmodule Banx.AccountTest do
  use Banx.DataCase, async: true

  alias Banx.Account

  alias Ecto.Changeset

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = %{current_balance: Decimal.new("1.00")}

      response = Account.changeset(params)

      assert %Changeset{changes: %{current_balance: _current_balance}, valid?: true} = response
    end

    test "when the current balance is lower than 0, returns an error" do
      params = %{current_balance: Decimal.new("-1.00")}

      response = Account.changeset(params)

      expected_response = %{current_balance: ["must be greater than or equal to 0"]}

      assert errors_on(response) == expected_response
    end
  end
end
