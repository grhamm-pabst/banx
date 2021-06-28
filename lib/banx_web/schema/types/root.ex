defmodule BanxWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias BanxWeb.Resolvers
  alias BanxWeb.Schema.Types
  alias Crudry.Middlewares.TranslateErrors

  import_types(Types.Custom.UUID4)
  import_types(Types.Account)
  import_types(Types.Transaction)
  import_types(Absinthe.Type.Custom)

  object :root_query do
    field :get_account, type: :account do
      arg(:id, non_null(:uuid4))

      resolve(&Resolvers.Account.get/2)
    end
  end

  object :root_mutation do
    field :create_account, type: :account do
      arg(:input, non_null(:create_account_input))

      resolve(&Resolvers.Account.create/2)
      middleware(TranslateErrors)
    end

    field :create_transaction, type: :transaction do
      arg(:input, non_null(:create_transaction_input))

      resolve(&Resolvers.Transaction.create/2)
      middleware(TranslateErrors)
    end
  end
end
