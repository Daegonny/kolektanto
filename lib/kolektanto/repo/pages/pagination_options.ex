defmodule Kolektanto.Repo.Pages.PaginationOptions do
  @moduledoc false

  @type t() :: %__MODULE__{
          page: non_neg_integer(),
          page_size: non_neg_integer()
        }

  defstruct page: 1, page_size: 10

  @spec build(non_neg_integer(), non_neg_integer()) :: t()
  def build(page, page_size) do
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
