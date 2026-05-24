defmodule EditableWorking do
  use Hologram.Component
  use Hologram.JS

  def init(_props, component, _server) do
    put_action(component, :setup_event)
  end

  def action(:setup_event, _, component) do
    JS.exec("""
    const editable = document.getElementById('working-edit');

    editable.addEventListener('pointerup', (e) => {
      Hologram.dispatchAction("collect_selected_format", "working-edit");
    });
    """)

    component
  end

  def action(:hello, _, component) do
    IO.inspect("hello")

    component
  end

  def template do
    ~HOLO"""
    <h2>Working!</h2>

    <div
      id="working-edit"
      style="border: 1px solid black; padding: 0.5rem"
      contenteditable
    >
      <p>Working contenteditable</p>
      <p>Select everything</p>
      <p>and try to deselect</p>
    </div>
    """
  end
end
