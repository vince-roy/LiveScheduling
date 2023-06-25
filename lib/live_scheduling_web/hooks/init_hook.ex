defmodule LiveSchedulingWeb.Hooks.Init do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    peer_data = get_connect_info(socket, :peer_data)

    socket =
      if peer_data[:address] do
        Phoenix.Component.assign(socket, :ip, peer_data[:address])
      else
        socket
      end

    {:cont, socket}
  end
end
