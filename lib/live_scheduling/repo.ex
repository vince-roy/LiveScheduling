defmodule LiveScheduling.Repo do
  use Ecto.Repo,
    otp_app: :live_scheduling,
    adapter: Ecto.Adapters.Postgres
end
