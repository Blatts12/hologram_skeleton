defmodule Parent do
  use Hologram.Component
  use Hologram.JS

  prop :items, :list, default: []

  def init(props, component, server) do
    component = put_state(component, :items, props.items)

    {component, server}
  end

  def action(:pause, _, component) do
    items = component.state.items_copy

    js =
      Enum.map_join(items, ";", fn item ->
        "Hologram.dispatchAction('stop_timer', '#{Child.cid(item)}')"
      end)

    JS.exec(js)

    component
  end

  def action(:unpause, _, component) do
    items = component.state.items_copy

    js =
      Enum.map_join(items, ";", fn item ->
        "Hologram.dispatchAction('setup_timer', '#{Child.cid(item)}')"
      end)

    JS.exec(js)

    component
  end

  def template do
    ~HOLO"""
    <div id="parent-1" style="margin-top: 10px;">
      <button $click="pause">Pause</button>
      <button $click="unpause">Unpause</button>
      <p>Number of items in parent: {length(@items)}</p>
      <div>
        {%for {item, index} <- Enum.with_index(@items)}
          <Child cid={Child.cid(item)} item={item} index={index} />
        {/for}
      </div>
    </div>
    """
  end
end
