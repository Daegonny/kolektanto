defmodule Kolektanto.Repo do
  use Ecto.Repo,
    otp_app: :kolektanto,
    adapter: Ecto.Adapters.Postgres
end
