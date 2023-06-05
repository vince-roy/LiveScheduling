defmodule LiveScheduling.Accounts do
  @moduledoc """
  The context for account-related operations.
  """
  alias LiveScheduling.Accounts.User
  alias LiveScheduling.Accounts.UserToken
  alias LiveScheduling.Repo
  import Ecto.Query

  # seconds
  @subscription_debounce_time 30

  def create_or_retrieve_user(attrs) do
    if user = Repo.one(query_users(attrs)) do
      {:ok, user}
    else
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    end
  end

  def create_user_token(args) do
    UserToken.changeset(args)
    |> Repo.insert()
  end

  @spec confirm_user_subscription(%{:token => binary()}) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def confirm_user_subscription(%{token: token}) do
    token =
      Repo.one(
        preload(
          query_tokens(%{
            token: token
          }),
          :user
        )
      )

    with %{user: %User{} = user} <- token,
         {:ok, _} <-
           Repo.update(User.changeset(user, %{subscribed_to_marketing_at: DateTime.utc_now()})) do
      {:ok, "Subscription confirmed"}
    else
      nil -> {:error, "Invalid token"}
      err -> err
    end
  end

  @doc """
  This function creates a user if they don't exist, and then creates a user token for them for
  the purpose of activating marketing emails.
  """
  @spec create_user_subscription(%{:email => binary()}) ::
          {:ok, UserToken.t()} | {:error, Ecto.Changeset.t()} | {:error, :string}
  def create_user_subscription(%{email: email}) do
    with {:ok, user} <- create_or_retrieve_user(%{email: email}),
         {:ok, nil} <-
           {:ok,
            Repo.one(
              query_tokens(%{
                inserted_at:
                  DateTime.add(DateTime.utc_now(), -@subscription_debounce_time, :second),
                context: :subscription,
                user_id: user.id
              })
            )},
         {:ok, _} <- create_user_token(%{user_id: user.id, context: :subscription}) do
      {:ok, "Please check your email to confirm your subscription"}
    else
      {:ok, %UserToken{}} ->
        {:error,
         "A subscription request was sent recently. Please wait #{@subscription_debounce_time} seconds before trying again"}

      res ->
        res
    end
  end

  def query_tokens(args) do
    Enum.reduce(
      args,
      UserToken,
      fn
        {:context, context}, query ->
          where(query, [u], u.context == ^context)

        {:inserted_at, time}, query ->
          where(query, [u], u.inserted_at >= ^time)

        {:user_id, user_id}, query ->
          where(query, [u], u.user_id == ^user_id)

        _, query ->
          query
      end
    )
  end

  def query_users(args) do
    Enum.reduce(
      args,
      User,
      fn
        {:email, email}, query ->
          where(query, [u], u.email == ^email)

        _, query ->
          query
      end
    )
  end
end
