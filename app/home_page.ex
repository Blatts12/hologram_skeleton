defmodule HologramSkeleton.HomePage do
  use Hologram.Page
  
  route "/"
  
  layout HologramSkeleton.DefaultLayout
  
  def template do
    ~HOLO"""
    <h1>Color input issue</h1>

    <ColorPicker cid="color_picker" />
    """
  end
end
