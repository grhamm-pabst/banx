defmodule Banx.Repo do
  use Ecto.Repo,
    otp_app: :banx,
    adapter: Ecto.Adapters.Postgres
end
