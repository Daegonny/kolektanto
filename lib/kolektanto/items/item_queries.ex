defmodule Kolektanto.Items.ItemQueries do
  @moduledoc """
  Queries for Item
  """
  alias Kolektanto.Items.Item
  alias Kolektanto.Items.ItemFilter

  import Ecto.Query

  def build(%ItemFilter{} = params) do
    base_query()
    |> filter(params)
    |> preload_tags()
  end

  defp base_query do
    from(item in Item, as: :item, distinct: true)
    |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tag)
  end

  defp filter(query, %ItemFilter{} = params) do
    params_map = Map.from_struct(params)

    query
    |> apply_simple_filters(params_map)
    |> maybe_filter_tags_must_have_all_one(params_map)
    |> maybe_filter_tags_must_have_all(params_map)
  end

  defp apply_simple_filters(query, params_map) do
    Enum.reduce(params_map, query, fn
      {:name, value}, query -> filter_name(query, value)
      _, query -> query
    end)
  end

  defp filter_name(query, name) do
    if is_binary(name) do
      where(query, [item: item], item.name == ^name)
    else
      query
    end
  end

  defp maybe_filter_tags_must_have_all_one(query, %{tags_must_have_one: tag_names}) do
    if is_list(tag_names) and Enum.any?(tag_names) do
      filter_tags_must_have_all_one(query, tag_names)
    else
      query
    end
  end

  defp filter_tags_must_have_all_one(query, tag_names) do
    tags_query =
      from(item in Item, as: :item)
      |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tags_must_have_one)
      |> where([tags_must_have_one: tag], tag.name in ^tag_names)

    from(q in query, join: t in subquery(tags_query), on: q.id == t.id)
  end

  defp maybe_filter_tags_must_have_all(query, %{tags_must_have_all: tag_names}) do
    if is_list(tag_names) and Enum.any?(tag_names) do
      filter_tags_must_have_all(query, tag_names)
    else
      query
    end
  end

  defp filter_tags_must_have_all(query, tag_names) do
    tags_count = length(tag_names)

    tags_query =
      from(item in Item, as: :item, distinct: true)
      |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tags_must_have_all)
      |> where([tags_must_have_all: tag], tag.name in ^tag_names)
      |> group_by([item: item], item.id)
      |> having([tags_must_have_all: tag], count(tag.id) == ^tags_count)

    from(q in query, join: t in subquery(tags_query), on: q.id == t.id)
  end

  defp preload_tags(query), do: preload(query, [:tags])
end
