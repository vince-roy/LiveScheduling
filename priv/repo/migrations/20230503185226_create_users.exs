defmodule LiveScheduling.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext
      add :first_name, :string
      add :last_name, :string
      add :subscribed_to_marketing_at, :utc_datetime

      timestamps()
    end
  end
end
