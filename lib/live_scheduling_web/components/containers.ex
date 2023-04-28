defmodule LiveSchedulingWeb.Containers do
  @moduledoc """
  Provides core UI components.

  At the first glance, this module may seem daunting, but its goal is
  to provide some core building blocks in your application, such modals,
  tables, and forms. The components are mostly markup and well documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  attr :class, :any, default: nil
  attr :padding, :boolean, default: true
  slot :inner_block

  @spec ctn_app(map) :: Phoenix.LiveView.Rendered.t()
  def ctn_app(assigns) do
    ~H"""
    <div class={["max-w-7xl", @class, "mx-auto"] ++ if @padding, do: ["px-4"], else: []}>
      <%= render_block(@inner_block) %>
    </div>
    """
  end
end
