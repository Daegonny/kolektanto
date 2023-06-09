defmodule Kolektanto.Item.Context.Behaviour do
  @moduledoc """
  Behaviours for item service manipulation
  """
  alias Kolektanto.Item
  @type item() :: map()

  @doc """
  Create an item
  """
  @callback create(item()) :: {:ok, Item.t()} | {:error, Ecto.Changeset}

  @doc """
  Create an item given a list of tag names
  """
  @callback create(item(), list(String.t())) :: {:ok, Item.t()} | {:error, Ecto.Changeset}
end
