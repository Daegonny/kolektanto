defmodule KolektantoWeb.ItemView do
  @moduledoc false
  use KolektantoWeb, :view

  def render("index.json", %{items_paginated: items_paginated}) do
    %{
      data: %{
        current_page: items_paginated.current_page,
        page_size: items_paginated.page_size,
        total_pages: items_paginated.total_pages,
        entries: render_many(items_paginated.entries, __MODULE__, "item.json")
      }
    }
  end

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
