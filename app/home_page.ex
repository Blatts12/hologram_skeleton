defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Content Editable</h1>

    <EditableWorking cid="working-edit" />

    <hr />

    <EditableNotWorking cid="not-working-edit" />
    """
  end
end
