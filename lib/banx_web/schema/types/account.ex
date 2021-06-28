defmodule BanxWeb.Schema.Types.Account do
  use Absinthe.Schema.Notation

  @desc "Logic account representation"
  object :account do
    field :id, non_null(:uuid4)
    field :current_balance, non_null(:decimal)
    field :transactions, list_of(:transaction)
  end

  input_object :create_account_input do
    field :current_balance, non_null(:decimal), description: "Account's initial balance"
  end
end
