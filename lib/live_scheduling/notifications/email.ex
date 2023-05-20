defmodule LiveScheduling.Notifications.Email do
  use Phoenix.Component
  import Phoenix.HTML
  import Swoosh.Email

  embed_templates "email/*"

  @callback build(map()) :: map()

  @spec base_email :: Swoosh.Email.t()
  def base_email, do: from(new(), {"LiveScheduling", "noreply@mail.scheduling.live"})

  @doc """
  Render the given template and assigns into the email body.
  """
  def render_body(%Swoosh.Email{} = email, template, assigns) do
    assigns =
      assigns
      |> Map.new()
      |> Map.put_new(:layout, {LiveScheduling.Notifications.Email, "email_layout"})

    html = Phoenix.Template.render_to_string(__MODULE__, template, "html", assigns)

    %{email | html_body: html}
  end

  defmacro __using__(_args) do
    quote do
      @behaviour LiveScheduling.Notifications.Email

      use LiveSchedulingWeb, :verified_routes

      import Swoosh.Email
      import LiveScheduling.Notifications.Email
    end
  end
end
