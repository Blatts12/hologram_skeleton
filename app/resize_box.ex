defmodule HologramSkeleton.ResizeBox do
  use Hologram.Component

  def init(_props, component, _server) do
    put_state(component, :resizes, 0)
  end

  def template do
    ~HOLO"""
    <div $resize.debounce(25)="count_resize" style="border: 1px solid; padding: 16px">
      Resized {@resizes} times
    </div>
    """
  end

  def action(:count_resize, _params, component) do
    put_state(component, :resizes, component.state.resizes + 1)
  end
end
