defmodule Kolektanto.Items do
  alias Kolektanto.Item
  alias Kolektanto.Repo
  alias Kolektanto.Tags

  @spec create(map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create(item) do
    tags = item[:tags] || item["tags"] || []

    %Item{}
    |> Item.changeset(item)
    |> Ecto.Changeset.put_assoc(:tags, Tags.upsert_all(tags))
    |> Repo.insert()
  end

  @spec get(binary()) :: {:ok, Kolektanto.Item.t()} | {:error, :not_found}
  def get(item_id) do
    case Repo.get(Item, item_id) do
      %Item{} = item -> {:ok, preload_tags(item)}
      nil -> {:error, :not_found}
    end
  end

  defp preload_tags(item), do: Repo.preload(item, :tags)
end
