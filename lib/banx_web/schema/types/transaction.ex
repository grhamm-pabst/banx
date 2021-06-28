defmodule BanxWeb.Schema.Types.Transaction do
  use Absinthe.Schema.Notation

  @desc "Logic training representation"
  object :transaction do
    field :id, non_null(:uuid4)
    field :amount, non_null(:decimal)
    field :sender_id, non_null(:uuid4)
    field :address_id, non_null(:uuid4)
    field :when, non_null(:naive_datetime)
  end

  input_object :create_transaction_input do
    field :amount, non_null(:decimal)
    field :sender_id, non_null(:uuid4)
    field :address_id, non_null(:uuid4)
  end
end
