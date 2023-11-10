defmodule Kolektanto.Items.ItemRepository do
  @moduledoc """
  Data access for Item
  """

  alias Kolektanto.Items.Item
  alias Kolektanto.Repo
  alias Kolektanto.Tags.Tag

  @spec create(map(), list(Tag.t())) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs, tags) do
    %Item{}
    |> Item.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
    |> Repo.normalize_result()
  end

  @spec get(binary()) :: {:ok, Kolektanto.Item.t()} | {:error, :not_found}
  def get(item_id) do
    Item
    |> Repo.get(item_id)
    |> preload_tags()
    |> Repo.normalize_result()
  end

  defp preload_tags(nil), do: nil
  defp preload_tags(item), do: Repo.preload(item, :tags)
end
