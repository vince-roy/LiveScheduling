defmodule LiveSchedulingWeb.PagesLive.Home do
  @moduledoc """
  Site home page
  """
  use LiveSchedulingWeb, :live_view
  alias LiveScheduling.Accounts.User

  @impl Phoenix.LiveView
  def handle_event("save", %{"user" => user}, socket) do
    Ecto.Changeset.apply_action(User.changeset(%User{}, user), :insert)
    |> case do
      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:ok, _msg} ->
        {:noreply,
         put_flash(
           assign(socket, :form, to_form(User.changeset(%User{}, %{}))),
           :info,
           "Check your email to confirm your subscription."
         )}
    end
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    changeset = User.changeset(%User{}, %{})
    socket = assign(socket, :form, to_form(changeset))
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <div class={["home-splash", "min-h-screen"]}>
      <.ctn_app class={["flex", "flex-col", "items-center", "py-24", "relative", "z-10"]}>
        <img class={["max-w-[300px]", "sm:max-w-[400px]"]} src={~p(/images/logo.svg)} />
        <p class={[
          "max-w-4xl",
          "mt-5",
          "mx-auto",
          "text-center",
          "text-zinc-600",
          "text-sm",
          "sm:text-xl"
        ]}>
          LiveScheduling is a scheduling as a service platform being built to make adding real-time scheduling to your website or app a breeze via its APIs and real-time widgets.
        </p>
        <p class="pt-6 pb-2 text-lg text-zinc-500">Sign Up for Product Updates</p>
        <.form class="mt-2" for={@form} phx-submit="save">
          <div class="flex" phx-feedback-for={:email}>
            <Form.input
              class={[
                "rounded-l-lg focus:ring-0",
                @form[:email].errors !== [] && "border-rose-400 focus:border-rose-400"
              ]}
              field={@form[:email]}
              placeholder="you@company.com"
              type="email"
            />
            <.button class={["rounded-l-none", @form[:email].errors !== [] && "bg-rose-400"]}>
              Sign Up
            </.button>
          </div>
          <.error :for={{msg, _} <- @form[:email].errors}><%= msg %></.error>
        </.form>
        <img class="mt-10 rounded-lg shadow-xl" src={~p(/images/home-splash.png)} />
      </.ctn_app>
    </div>
    """
  end
end
