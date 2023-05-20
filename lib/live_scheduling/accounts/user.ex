defmodule LiveScheduling.Accounts.User do
  @moduledoc """
  User accounts schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :subscribed_to_marketing_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :subscribed_to_marketing_at])
    |> validate_required([:email])
  end
end
