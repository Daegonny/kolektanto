defmodule KolektantoWeb.ItemView do
  @moduledoc false
  use KolektantoWeb, :view

  def render("show.json", %{item: item}) do
    %{data: render_one(item, __MODULE__, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      name: item.name,
      tags: Enum.map(item.tags, & &1.name)
    }
  end
end
