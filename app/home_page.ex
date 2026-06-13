defmodule HologramSkeleton.HomePage do
  use Hologram.Page

  route "/"

  layout HologramSkeleton.DefaultLayout

  def template do
    ~HOLO"""
    <h1>Hello from Hologram!</h1>

    <button $click={action: :add_item, target: Group.cid("main")}>
      Add item
    </button>

    <Group cid={Group.cid("main")} id="main" />
    """
  end
end
