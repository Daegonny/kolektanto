defmodule Kolektanto.Items do
  @moduledoc """
  Implements behaviours for Items
  """
  alias Kolektanto.Items.Item
  alias Kolektanto.Items.ItemRepository
  alias Kolektanto.Errors.FieldValidationError

  @behaviour Kolektanto.Items.Behaviour

  @type item() :: map()
  @type id() :: binary()

  @impl true
  @spec get(id()) :: {:ok, Item.t()} | {:error, :not_found}
  def get(id), do: ItemRepository.get(id)

  @impl true
  @spec save(item(), list(String.t())) ::
          {:ok, Item.t()} | {:error, :field_validation, list(FieldValidationError.t())}
  def save(item, tag_names \\ []) do
    with {:ok, tags} <- tags().save_all(tag_names) do
      ItemRepository.create(item, tags)
    end
  end

  defp tags, do: Application.get_env(:kolektanto, :tags)
end
