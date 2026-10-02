defmodule HologramSkeleton.OtherPage do
  use Hologram.Page

  alias Hologram.UI.Link
  alias HologramSkeleton.HomePage

  route "/other"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Other page</h1>
    <Link to={HomePage}>Back home</Link>
    """
  end
end
