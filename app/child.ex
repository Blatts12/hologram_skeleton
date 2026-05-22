defmodule Child do
  use Hologram.Component
  use Hologram.JS

  prop :index, :integer, default: nil
  prop :item, :map, default: %{id: -1}
  prop :time, :integer, default: 0
  prop :bg, :integer, default: nil

  def init(props, component) do
    component
    |> put_state(:bg, bg_color(props.item.id))
    |> put_state(:id, props.item.id)
    |> put_state(:time, 0)
    |> put_state(:interval_id, nil)
    |> put_action(:setup_timer)
  end

  def action(:setup_timer, _, component) do
    interval_id =
      JS.exec("""
        return setInterval(() => {
          Hologram.dispatchAction("tick", "#{cid(component.state)}");
        }, 1000)
      """)

    put_state(component, :interval_id, interval_id)
  end

  def action(:tick, _, component) do
    time = component.state.time
    put_state(component, :time, time + 1)
  end

  def action(:stop_timer, _, component) do
    if Map.get(component.state, :interval_id) do
      JS.call(:clearInterval, [component.state.interval_id])
      put_state(component, :interval_id, nil)
    else
      component
    end
  end

  def action(:random_bg, _, component) do
    bg = random_bg_color()
    put_state(component, :bg, bg)
  end

  def template do
    ~HOLO"""
    <div id={cid(@item)} style={"background-color: #{@bg}; padding: 0.5rem; margin-top: 0.25rem"}>
      <h2>
        {@item.name}
        {%if not is_nil(@index)}
          - {@index}
        {/if}
      </h2>
      <p>{@item.description}</p>
      <p>Time: {@time}</p>
      <button $click={action: :remove_item, target: "page", params: %{id: @item.id}}>
        Remove
      </button>
      <button $click="random_bg">
        Change BG
      </button>
    </div>
    """
  end

  def cid(%{id: id}), do: "child-#{id}"

  @colors ["#FFB3B3", "#FFD9B3", "#FFFFB3", "#B3FFB3", "#B3D9FF", "#D9B3FF"]
  @colors_len length(@colors)

  defp bg_color(id) do
    index = rem(id, @colors_len)
    Enum.at(@colors, index)
  end

  defp random_bg_color, do: Enum.random(@colors)
end
