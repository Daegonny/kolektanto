defmodule Kolektanto.Items do
  @moduledoc """
  Implements behaviours for Items
  """

  alias Kolektanto.Items.Behaviour
  alias Kolektanto.Items.Item
  alias Kolektanto.Items.ItemRepository
  alias Kolektanto.Errors.FieldValidationError
  alias Kolektanto.Repo.Pages.Page

  @behaviour Kolektanto.Items.Behaviour

  @impl true
  @spec fetch(Behaviour.id()) :: {:ok, Item.t()} | {:error, :not_found}
  def fetch(id), do: ItemRepository.fetch(id)

  @impl true
  @spec list(Behaviour.opts()) :: Page.t()
  def list(opts), do: ItemRepository.list(opts)

  @impl true
  @spec save(Behaviour.item()) ::
          {:ok, Kolektanto.Items.Item.t()}
          | {:error, :field_validation, [FieldValidationError.t()]}
  def save(item, tag_names \\ []) do
    with {:ok, tags} <- tags().save_all(tag_names) do
      ItemRepository.create(item, tags)
    end
  end

  defp tags, do: Application.get_env(:kolektanto, :tags)
end
