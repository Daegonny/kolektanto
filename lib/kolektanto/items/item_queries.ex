defmodule Kolektanto.Items.ItemQueries do
  @moduledoc """
  Queries for Item
  """
  alias Kolektanto.Items.Item

  import Ecto.Query

  def filter_with_any_tags(tag_names) do
    from(item in Item, as: :item, distinct: true)
    |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tag)
    |> where([tag: tag], tag.name in ^tag_names)
    |> preload(:tags)

    # |> Repo.all()
    # |> then(fn items -> {:ok, items} end)
  end

  def filter_with_all_tags(tag_names) do
    tags_count = length(tag_names)

    from(item in Item, as: :item)
    |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tag)
    |> where([tag: tag], tag.name in ^tag_names)
    |> group_by([item: item], item.id)
    |> having([tag: tag], count(tag.id) == ^tags_count)
    |> preload(:tags)

    # |> Repo.all()
    # |> then(fn items -> {:ok, items} end)
  end
end
