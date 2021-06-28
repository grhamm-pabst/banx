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
    |> validate_number(:amount, greater_than: 0)
    |> validate_destination()
    |> put_date()
  end

  defp validate_destination(
         %Changeset{
           changes: %{sender_id: sender_id, address_id: address_id}
         } = changeset
       ) do
    if sender_id != address_id,
      do: changeset,
      else:
        add_error(changeset, :sender_id, "Sender should not be the same as the Address",
          validation: :destination
        )
  end

  defp put_date(%Changeset{valid?: true} = changeset) do
    date = NaiveDateTime.local_now()
    change(changeset, %{when: date})
  end

  defp put_date(changeset), do: changeset
end
