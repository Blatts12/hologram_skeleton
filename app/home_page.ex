defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  alias Hologram.UI.Link
  alias HologramSkeleton.OtherPage
  alias HologramSkeleton.ResizeBox

  route "/"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Hello from Hologram!</h1>
    <ResizeBox cid="resize-box" />
    <Link to={OtherPage}>Go to other page</Link>
    """
  end
end
