defmodule Banx.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Banx.Account
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @fields [:amount, :when, :address_id, :sender_id]
  @required_fields @fields -- [:when]

  schema "transactions" do
    field :amount, :decimal
    field :when, :naive_datetime

    belongs_to :address, Account, foreign_key: :address_id
    belongs_to :sender, Account, foreign_key: :sender_id

    timestamps()
  end

  def changeset(transaction_params) do
    %__MODULE__{}
    |> cast(transaction_params, @fields)
    |> validate_required(@required_fields)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> put_date()
  end

  defp put_date(%Changeset{valid?: true} = changeset) do
    date = NaiveDateTime.local_now()
    change(changeset, %{when: date})
  end

  defp put_date(changeset), do: changeset
end
