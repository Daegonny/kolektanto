defmodule Kolektanto.Items.ItemRepository do
  @moduledoc """
  Data access for Item
  """

  alias Kolektanto.Items.Item
  alias Kolektanto.Items.ItemQueries
  alias Kolektanto.Repo
  alias Kolektanto.Repo.Pages.Page
  alias Kolektanto.Tags.Tag

  @spec create(map(), list(Tag.t())) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs, tags) do
    %Item{}
    |> Item.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
    |> Repo.insert()
    |> Repo.normalize_result()
  end

  @spec fetch(binary()) :: {:ok, Kolektanto.Item.t()} | {:error, :not_found}
  def fetch(item_id) do
    Item
    |> Repo.get(item_id)
    |> preload_tags()
    |> Repo.normalize_result()
  end

  @spec list(map(), non_neg_integer(), non_neg_integer()) :: Page.t()
  def list(opts \\ %{}, page \\ 1, page_size \\ 10) do
    ItemQueries.build(opts)
    |> Repo.Pages.paginate(page, page_size)
  end

  defp preload_tags(nil), do: nil
  defp preload_tags(item), do: Repo.preload(item, :tags)
end
