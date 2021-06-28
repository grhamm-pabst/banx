defmodule BanxWeb.Resolvers.Account do
  alias Banx.Accounts.Create
  alias Banx.Accounts.Get

  def create(%{input: input}, _context) do
    Create.call(input)
  end

  def get(%{id: id}, _context) do
    Get.by_id(id)
  end
end
