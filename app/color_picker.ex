defmodule ColorPicker do
  use Hologram.Component
  use Hologram.JS

  def init(_props, component, _server) do
    component
    |> put_state(upper: "#FF0000", lower: "#ff0000", ticks: 0)
    |> put_action(:count_value_writes)
  end

  # Counts every write the renderer makes to a color input's value. The count goes straight into
  # the DOM: putting it in state would re-render, and each render writes again.
  def action(:count_value_writes, _params, component) do
    JS.exec("""
    if (!window.__colorWrites) {
      window.__colorWrites = {};
      const desc = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, "value");

      Object.defineProperty(HTMLInputElement.prototype, "value", {
        ...desc,
        set(v) {
          if (this.type === "color") {
            window.__colorWrites[this.id] = (window.__colorWrites[this.id] || 0) + 1;
            document.getElementById(`${this.id}_writes`).textContent = window.__colorWrites[this.id];
          }

          desc.set.call(this, v);
        },
      });
    }
    """)

    put_action(component, name: :tick, delay: 100)
  end

  # Re-renders every 100 ms, like any unrelated state change would
  def action(:tick, _params, component) do
    component
    |> put_state(:ticks, component.state.ticks + 1)
    |> put_action(name: :tick, delay: 100)
  end

  def action(:pick_upper, params, component) do
    put_state(component, :upper, String.upcase(params.event.value))
  end

  def action(:pick_lower, params, component) do
    put_state(component, :lower, params.event.value)
  end

  def template do
    ~HOLO"""
    <h2>Controlled color input</h2>
    <p>Renders: {@ticks}</p>

    <p>
      <label for="upper">State uppercase (bug):</label>
      <input type="color" id="upper" value={@upper} $input="pick_upper" />
      state = {@upper}, value writes = <span id="upper_writes">0</span>
    </p>

    <p>
      <label for="lower">State lowercase (control):</label>
      <input type="color" id="lower" value={@lower} $input="pick_lower" />
      state = {@lower}, value writes = <span id="lower_writes">0</span>
    </p>
    """
  end
end
