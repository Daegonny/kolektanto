defmodule Kolektanto.Items.Behaviour do
  @moduledoc """
  Behaviours for Items
  """

  alias Kolektanto.Items.Item
  alias Kolektanto.Errors.FieldValidationError
  alias Kolektanto.Repo.Pages.Page

  @type item() :: map()
  @type id() :: binary()

  @type opts() :: %{
          optional(:name) => String.t(),
          optional(:having_one_of_tags) => list(String.t()),
          optional(:having_all_tags) => list(String.t()),
          optional(:page) => pos_integer(),
          optional(:page_size) => pos_integer()
        }

  @doc """
    Fetches an item by id
  """
  @callback fetch(id()) :: {:ok, Item.t()} | {:error, :not_found}

  @doc """
    Lists items filtered and paginated according to opts criteria
  """
  @callback list(opts()) :: Page.t()

  @doc """
    Creates an item alongside its tags
  """
  @callback save(item(), list(String.t())) ::
              {:ok, Item.t()} | {:error, :field_validation, list(FieldValidationError.t())}
end
