defmodule LiveScheduling.Accounts.UserToken do
  @moduledoc """
  Schema to track user authentication
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveScheduling.Accounts.User
  @rand_size 32
  # 30 days
  @subscription_validity_in_seconds 60 * 60 * 24 * 30

  schema "user_tokens" do
    field :context, Ecto.Enum, values: [:subscription]
    field :deleted_at, :utc_datetime
    field :ip, EctoNetwork.INET
    field :token, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{
      token: :crypto.strong_rand_bytes(@rand_size)
    }
    |> changeset(attrs)
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:token, :context, :deleted_at, :ip, :user_id])
    |> validate_required([:token, :context, :ip, :user_id])
  end

  def expiry_for_context(:subscription), do: @subscription_validity_in_seconds
end
