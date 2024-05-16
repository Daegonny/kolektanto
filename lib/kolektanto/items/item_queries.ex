defmodule Kolektanto.Items.ItemQueries do
  @moduledoc """
  Queries for Item
  """
  alias Kolektanto.Items.Item

  import Ecto.Query

  def build(params) do
    base_query()
    |> filter(params)
    |> preload_tags()
  end

  defp base_query do
    from(item in Item, as: :item, distinct: true)
    |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tag)
  end

  defp filter(query, params) do
    query
    |> apply_simple_filters(params)
    |> having_one_of_tags(params)
    |> having_all_tags(params)
  end

  defp apply_simple_filters(query, params) do
    Enum.reduce(params, query, fn
      {:name, value}, query -> filter_name(query, value)
      _, query -> query
    end)
  end

  defp filter_name(query, name) do
    if is_binary(name) and bit_size(name) > 0 do
      where(query, [item: item], item.name == ^name)
    else
      query
    end
  end

  defp having_one_of_tags(query, %{having_one_of_tags: tag_names}) do
    if is_list(tag_names) and Enum.any?(tag_names) do
      filter_having_one_of_tags(query, tag_names)
    else
      query
    end
  end

  defp having_one_of_tags(query, _params), do: query

  defp filter_having_one_of_tags(query, tag_names) do
    tags_query =
      from(item in Item, as: :item)
      |> join(:inner, [item: item], tag in assoc(item, :tags), as: :having_one_of_tags)
      |> where([having_one_of_tags: tag], tag.name in ^tag_names)

    from(q in query, join: t in subquery(tags_query), on: q.id == t.id)
  end

  defp having_all_tags(query, %{having_all_tags: tag_names}) do
    if is_list(tag_names) and Enum.any?(tag_names) do
      filter_having_all_tags(query, tag_names)
    else
      query
    end
  end

  defp having_all_tags(query, _params), do: query

  defp filter_having_all_tags(query, tag_names) do
    tags_count = length(tag_names)

    tags_query =
      from(item in Item, as: :item, distinct: true)
      |> join(:inner, [item: item], tag in assoc(item, :tags), as: :having_all_tags)
      |> where([having_all_tags: tag], tag.name in ^tag_names)
      |> group_by([item: item], item.id)
      |> having([having_all_tags: tag], count(tag.id) == ^tags_count)

    from(q in query, join: t in subquery(tags_query), on: q.id == t.id)
  end

  defp preload_tags(query), do: preload(query, [:tags])
end
