defmodule LiveScheduling.Notifications do
  alias LiveScheduling.Notifications.Email
  alias LiveScheduling.Mailer

  def deliver_confirm_subscription_email(args) do
    Email.ConfirmSubscription.build(args)
    |> email_deliver()
  end

  defp email_deliver(email) do
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
