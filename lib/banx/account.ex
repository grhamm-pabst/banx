defmodule Banx.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Banx.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}

  @foreign_key_type :binary_id

  schema "accounts" do
    field :current_balance, :decimal

    has_many :sended, Transaction, foreign_key: :sender_id
    has_many :received, Transaction, foreign_key: :address_id

    field :transactions, {:array, :map}, virtual: true

    timestamps()
  end

  def changeset(account \\ %__MODULE__{}, account_params) do
    account
    |> cast(account_params, [:current_balance])
    |> validate_required([:current_balance])
    |> validate_number(:current_balance, greater_than_or_equal_to: 0)
  end
end
