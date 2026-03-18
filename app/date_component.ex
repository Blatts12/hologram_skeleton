defmodule HologramSkeleton.DateComponent do
  use Hologram.Component

  prop :date, :any, default: nil

  def action(:date1, _props, component) do
    date = Date.utc_today()
    put_state(component, :date, date)
  end

  def action(:date2, _props, component) do
    date = ~D[2022-01-01]
    put_state(component, :date, date)
  end

  def action(:date3, _props, component) do
    date = %Date{year: 2022, month: 1, day: 1, calendar: Calendar.ISO}
    put_state(component, :date, date)
  end

  def template do
    ~HOLO"""
    <div>
      <button $click="date1">Date.utc_today()</button>
      <button $click="date2">~D[2022-01-01]</button>
      <button $click="date3">struct</button>
      <hr />
      {@date}
    </div>
    """
  end
end
