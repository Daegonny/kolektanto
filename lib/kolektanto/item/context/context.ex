defmodule Kolektanto.Item.Context do
  @moduledoc """
  Implements behaviours of item context
  """
  alias Kolektanto.Item
  alias Kolektanto.Error.FieldValidationError
  @behaviour Kolektanto.Item.Context.Behaviour

  @type item() :: map()

  @impl true
  @spec create(item(), list(String.t())) ::
          {:ok, Item.t()} | {:error, :field_validation, list(FieldValidationError.t())}
  def create(item, tag_names \\ []) do
    tags = tags().upsert_all(tag_names)

    case items().create(item, tags) do
      {:ok, item} ->
        {:ok, item}

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = FieldValidationError.build_from(changeset)
        {:error, :field_validation, errors}
    end
  end

  defp tags, do: Application.get_env(:kolektanto, :tags)
  defp items, do: Application.get_env(:kolektanto, :items)
end
