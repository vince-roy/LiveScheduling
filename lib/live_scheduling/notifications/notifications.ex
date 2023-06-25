defmodule LiveScheduling.Notifications do
  @moduledoc """
  The context for notification-related operations.
  """
  alias LiveScheduling.Mailer
  alias LiveScheduling.Notifications.Email

  def deliver_confirm_subscription_email(%Email.ConfirmSubscription{} = args) do
    Email.ConfirmSubscription.build(args)
    |> email_deliver()
  end

  defp email_deliver(email) do
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
