defmodule LiveScheduling.Notifications.Email.ConfirmSubscription do
  @moduledoc """
  Template for confirming a subscription.
  """
  use LiveScheduling.Notifications.Email

  use TypedStruct

  typedstruct do
    @typedoc "A person"

    field :confirm_link, String.t(), enforce: true
    field :email, String.t(), enforce: true
    field :footer, String.t(), enforce: true
    field :text, String.t(), enforce: true
    field :title, String.t(), enforce: true
  end

  @impl true
  @spec build(LiveScheduling.Notifications.Email.ConfirmSubscription.t()) :: Swoosh.Email.t()
  def build(%__MODULE__{
        confirm_link: confirm_link,
        email: email,
        footer: footer,
        text: text,
        title: title
      }) do
    base_email()
    |> to(email)
    |> subject("Confirm Subscription")
    |> render_body("confirm_subscription", %{
      confirm_link: confirm_link,
      footer: footer,
      text: text,
      title: title
    })
  end
end
