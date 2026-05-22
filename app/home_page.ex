defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"

  layout HologramSkeleton.DefaultLayout

  def init(_, component, server) do
    component =
      component
      |> put_state(:count, 2)
      |> put_state(:items, [
        %{
          id: 0,
          name: "Item 0",
          description: "Description 0"
        },
        %{
          id: 1,
          name: "Item 1",
          description: "Description 1"
        }
      ])

    {component, server}
  end

  def action(:add_item, _, component) do
    items =
      component.state.items ++
        [
          %{
            id: component.state.count,
            name: "Item #{component.state.count}",
            description: "Description #{component.state.count}"
          }
        ]

    component
    |> put_state(:items, items)
    |> put_state(:count, component.state.count + 1)
  end

  def action(:remove_item, %{id: id}, component) do
    items = Enum.reject(component.state.items, &(&1.id == id))
    put_state(component, :items, items)
  end

  def template do
    ~HOLO"""
      <h1>Hello from Hologram!</h1>
      <button $click="add_item">Add Item</button>

      <p>Number of items in page: {length(@items)}</p>

      <Parent cid="parent-1" items={@items} />
    """
  end
end
