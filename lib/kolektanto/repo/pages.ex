defmodule Kolektanto.Repo.Pages do
  @moduledoc """
    Paginate queries
  """

  require Ecto.Query
  alias Ecto.Query
  alias Kolektanto.Repo.Pages.PaginationOptions
  alias Kolektanto.Repo.Pages.Page
  alias Kolektanto.Repo

  @spec paginate(Ecto.Query.t(), map()) :: Page.t()
  def paginate(%Query{} = query, params \\ %{}) do
    opts = PaginationOptions.build(params)
    {limit, offset} = get_limit_offset(opts.page, opts.page_size)
    entries = get_entries(query, limit, offset)
    total_pages = get_total_pages(query, opts.page_size)

    %Page{
      entries: entries,
      current_page: opts.page,
      page_size: opts.page_size,
      total_pages: total_pages
    }
  end

  defp get_limit_offset(page, page_size) do
    offset = (page - 1) * page_size
    limit = page_size
    {limit, offset}
  end

  defp get_entries(query, limit, offset) do
    query
    |> Query.limit(^limit)
    |> Query.offset(^offset)
    |> Repo.all()
  end

  defp get_total_pages(query, page_size) do
    total_entries = Repo.aggregate(query, :count, :id)
    Kernel.ceil(total_entries / page_size)
  end
end
