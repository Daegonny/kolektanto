defmodule Kolektanto.Item.Items.Behaviour do
  @moduledoc """
  Behaviours for items data access.
  """
  alias Ecto.Changeset
  alias Kolektanto.Item
  alias Kolektanto.Tag

  @type item() :: map()

  @doc """
  Create item
  """
  @callback create(item) :: {:ok, Item.t()} | {:error, Changeset.t()}

  @doc """
  Create item with tags
  """
  @callback create(item, list(Tag.t())) :: {:ok, Item.t()} | {:error, Changeset.t()}

  @doc """
  Get item by id
  """
  @callback get(binary()) :: {:ok, Item.t()} | {:error, :not_found}
end
