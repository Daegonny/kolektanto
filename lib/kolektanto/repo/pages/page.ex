defmodule Kolektanto.Repo.Pages.Page do
  @moduledoc false

  @type t() :: %__MODULE__{
          entries: list(any()),
          current_page: non_neg_integer(),
          page_size: non_neg_integer(),
          total_pages: non_neg_integer()
        }

  defstruct entries: [], current_page: nil, page_size: nil, total_pages: nil
end
