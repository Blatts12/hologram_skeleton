defmodule EditableNotWorking do
  use Hologram.Component

  def action(:hello, _, component) do
    IO.inspect("hello")

    component
  end

  def template do
    ~HOLO"""
    <h2>Not working!</h2>

    <div
      id="working-edit"
      style="border: 1px solid black; padding: 0.5rem"
      contenteditable
      $pointer_up="hello"
    >
      <p>Not working contenteditable</p>
      <p>Select everything</p>
      <p>and try to deselect</p>
    </div>
    """
  end
end
