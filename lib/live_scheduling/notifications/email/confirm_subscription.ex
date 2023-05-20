defmodule LiveScheduling.Notifications.Email.ConfirmSubscription do
  @moduledoc """
  Template for confirming a subscription.
  """
  use LiveScheduling.Notifications.Email

  @impl true
  def build(%{
        confirm_link: confirm_link,
        email: email
      }) do
    base_email()
    |> to(email)
    |> subject("Confirm Subscription")
    |> render_body("confirm_subscription", %{
      confirm_link: confirm_link,
      footer: "",
      text: "",
      title: ""
    })
  end
end
