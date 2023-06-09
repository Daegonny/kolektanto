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

  defp preload_tags(item), do: Repo.preload(item, :tags)
end
