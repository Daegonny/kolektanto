defmodule Kolektanto.Items.Behaviour do
  @moduledoc """
  Behaviours for Items
  """

  alias Kolektanto.Items.Item
  alias Kolektanto.Errors.FieldValidationError

  @type item() :: map()
  @type id() :: binary()

  @doc """
  Gets an item by id
  """
  @callback fetch(id()) :: {:ok, Item.t()} | {:error, :not_found}

  @doc """
  Creates an item
  """
  @callback save(item(), list(String.t())) ::
              {:ok, Item.t()} | {:error, :field_validation, list(FieldValidationError.t())}
end
