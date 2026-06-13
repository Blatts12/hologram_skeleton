defmodule Group do
  use Hologram.Component

  prop :id, :string
  prop :items, :list, default: []

  @background_colors [
    "#fde2e4",
    "#fff1e6",
    "#e2ece9",
    "#cddafd",
    "#dfe7fd",
    "#fad2e1",
    "#e2eafc",
    "#d0f4de"
  ]

  @impl true
  def init(props, component, server) do
    component =
      component
      |> put_state(:items, props.items)
      |> put_state(:next_id, length(props.items))

    {component, server}
  end

  @impl true
  def action(:add_item, _params, component) do
    id = component.state.next_id
    color = Enum.at(@background_colors, :rand.uniform(length(@background_colors)) - 1)
    new_items = component.state.items ++ [%{id: id, color: color}]

    component
    |> put_state(:items, new_items)
    |> put_state(:next_id, id + 1)
  end

  def action(:delete_item, %{id: id}, component) do
    new_items = Enum.reject(component.state.items, &(Map.get(&1, :id) == id))
    put_state(component, :items, new_items)
  end

  @impl true
  def template do
    ~HOLO"""
    <div id={cid(@id)}>
      <p>Number of items in group: {length(@items)}</p>
      <p>with_index</p>
      <div class="flex flex-row gap-2">
        {%for {item, index} <- Enum.with_index(@items)}
          <Child cid={Child.cid(item)} item={item} index={index} group_id={@id} />
        {/for}
      </div>

      <p>parsed</p>
      <div class="flex flex-row gap-2">
        {%for item <- @items}
          <Child cid={Child.cid(item)} item={item} group_id={@id} />
        {/for}
      </div>
    </div>
    """
  end

  @spec cid(String.t()) :: String.t()
  def cid(id), do: "group-#{id}"

  @spec parse_items(list(map())) :: list(map())
  def parse_items(items) do
    items
    |> Enum.with_index()
    |> Enum.map(fn {item, index} ->
      %{item | index: index}
    end)
  end
end
