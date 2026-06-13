defmodule Child do
  use Hologram.Component

  alias Group

  @swipe_in_max 16
  @swipe_out_threshold 120
  @swipe_out_max 360

  prop :item, :map, default: %{}
  prop :index, :integer, default: 0
  prop :group_id, :string

  @impl true
  def init(props, component) do
    component =
      component
      |> put_state(:item, props.item)
      |> put_state(:index, props.index)
      |> put_state(:group_id, props.group_id)
      |> put_state(:offset, 0)
      |> put_state(:transition, "none")
      |> put_state(:opacity, 1)
      |> put_state(:swiping?, false)
      |> put_state(:swipe_start_x, nil)
      |> put_state(:dismissed?, false)

    component
  end

  @impl true
  def action(:swipe_start, %{event: %{client_x: client_x}}, component) do
    if component.state.dismissed? do
      component
    else
      component
      |> put_state(:swiping?, true)
      |> put_state(:swipe_start_x, client_x)
      |> put_state(:transition, "none")
    end
  end

  def action(:swipe_move, %{event: %{client_x: client_x}}, component) do
    handle_swipe_move(component, client_x)
  end

  def action(:swipe_end, _params, component) do
    handle_swipe_end(component)
  end

  defp handle_swipe_move(%{state: %{swiping?: false}} = component, _client_x), do: component
  defp handle_swipe_move(%{state: %{dismissed?: true}} = component, _client_x), do: component

  defp handle_swipe_move(component, client_x) do
    dx = client_x - component.state.swipe_start_x
    sign = if dx >= 0, do: 1, else: -1

    if abs(dx) >= @swipe_out_threshold do
      component
      |> put_state(:offset, sign * @swipe_out_max)
      |> put_state(:opacity, 0)
      |> put_state(:transition, "transform 0.2s ease-in, opacity 0.2s ease-in")
      |> put_state(:swiping?, false)
      |> put_state(:dismissed?, true)
      |> dispatch_delete()
    else
      put_state(component, :offset, sign * min(abs(dx) * 0.1, @swipe_in_max))
    end
  end

  defp handle_swipe_end(%{state: %{swiping?: false}} = component), do: component
  defp handle_swipe_end(%{state: %{dismissed?: true}} = component), do: component

  defp handle_swipe_end(component) do
    component
    |> put_state(:offset, 0)
    |> put_state(:transition, "transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)")
    |> put_state(:swiping?, false)
    |> put_state(:swipe_start_x, nil)
  end

  defp dispatch_delete(component) do
    put_action(component,
      name: :delete_item,
      target: Group.cid(component.state.group_id),
      params: %{id: Map.get(component.state.item, :id)},
      delay: 200
    )
  end

  @impl true
  def template do
    ~HOLO"""
    <div
      id={cid(@item)}
      class="flex flex-col gap-2 rounded-lg"
      style={"transform: translateX(#{@offset}px); transition: #{@transition}; opacity: #{@opacity}; touch-action: pan-y; background-color: #{Map.get(@item, :color, "#ffffff")}; padding: 1rem;"}
      $pointer_down="swipe_start"
      $pointer_move="swipe_move"
      $pointer_up="swipe_end"
    >
      <p>Item #{Map.get(@item, :index, @index)}</p>
    </div>
    """
  end

  @spec cid(map() | String.t()) :: String.t()
  def cid(%{id: id}), do: cid(id)
  def cid(id), do: "child-#{id}"
end
