defmodule Kolektanto.Repo.Pages.PaginationOptions do
  @moduledoc false

  @default_page 1
  @default_page_size 10

  @type opts() :: %{
          optional(:page) => pos_integer(),
          optional(:page_size) => pos_integer()
        }

  @type t() :: %__MODULE__{
          page: non_neg_integer(),
          page_size: non_neg_integer()
        }

  defstruct page: @default_page, page_size: @default_page_size

  @spec build(map()) :: t()
  def build(opts) do
    page = Map.get(opts, :page, @default_page)
    page_size = Map.get(opts, :page_size, @default_page_size)

    if valid_values?(page, page_size) do
      %__MODULE__{
        page: page,
        page_size: page_size
      }
    else
      %__MODULE__{}
    end
  end

  defp valid_values?(page, page_size),
    do: is_integer(page) && is_integer(page_size) && page >= 1 && page_size >= 1
end
