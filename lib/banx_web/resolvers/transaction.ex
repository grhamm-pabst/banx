defmodule BanxWeb.Resolvers.Transaction do
  alias Banx.Transactions.Create

  def create(%{input: input}, _context) do
    Create.call(input)
  end
end
