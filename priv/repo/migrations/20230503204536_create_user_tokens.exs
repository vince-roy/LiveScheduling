defmodule LiveScheduling.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :token, :binary
      add :context, :string
      add :deleted_at, :utc_datetime
      add :ip, :inet
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_tokens, [:user_id])
  end
end
