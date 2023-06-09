defmodule Kolektanto.Item.Context.Behaviour do
  @moduledoc """
  Behaviours for item service manipulation
  """
  alias Kolektanto.Item
  alias Kolektanto.Error.FieldValidationError
  @type item() :: map()

  @doc """
  Creates an item
  """
  @callback create(item(), list(String.t())) ::
              {:ok, Item.t()} | {:error, :field_validation, list(FieldValidationError.t())}
end
