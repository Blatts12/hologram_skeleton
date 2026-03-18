defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"

  layout HologramSkeleton.DefaultLayout

  alias HologramSkeleton.DateComponent

  def template do
    ~HOLO"""
    <h1>Hello from Hologram!</h1>
    <DateComponent cid="date" />
    """
  end
end
