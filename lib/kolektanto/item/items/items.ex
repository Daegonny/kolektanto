defmodule Kolektanto.Item.Items do
  @moduledoc """
  Implementation for items data access
  """
  alias Kolektanto.Item
  alias Kolektanto.Repo
  alias Kolektanto.Tag

  @behaviour Kolektanto.Item.Items.Behaviour
  @type item() :: map()

  @impl true
  @spec create(item()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create(item) do
    create(item, [])
  end

  @impl true
  @spec create(item(), list(Tag.t())) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create(item, tags) do
    %Item{}
    |> Item.changeset(item)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
  end

  @impl true
  @spec get(binary()) :: {:ok, Kolektanto.Item.t()} | {:error, :not_found}
  def get(item_id) do
    case Repo.get(Item, item_id) do
      %Item{} = item -> {:ok, preload_tags(item)}
      nil -> {:error, :not_found}
    end
  end

  # def filter_with_any_tags(tag_names) do
  #   from(item in Item, as: :item, distinct: true)
  #   |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tag)
  #   |> where([tag: tag], tag.name in ^tag_names)
  #   |> preload(:tags)
  #   |> Repo.all()
  #   |> then(fn items -> {:ok, items} end)
  # end

  # def filter_with_all_tags(tag_names) do
  #   tags_count = length(tag_names)

  #   from(item in Item, as: :item)
  #   |> join(:inner, [item: item], tag in assoc(item, :tags), as: :tag)
  #   |> where([tag: tag], tag.name in ^tag_names)
  #   |> group_by([item: item], item.id)
  #   |> having([tag: tag], count(tag.id) == ^tags_count)
  #   |> preload(:tags)
  #   |> IO.inspect()
  #   |> Repo.all()
  #   |> IO.inspect()
  #   |> then(fn items -> {:ok, items} end)
  # end

  defp preload_tags(item), do: Repo.preload(item, :tags)
end
