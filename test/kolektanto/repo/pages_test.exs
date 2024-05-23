defmodule Kolektanto.Repo.PagesTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true

  import Ecto.Query

  alias Kolektanto.Items.Item
  alias Kolektanto.Repo.Pages
  alias Kolektanto.Repo.Pages.Page

  setup %{} do
    names = ~w(a b c d e f g h i j)

    for name <- names do
      insert(:item, name: name, tags: [])
    end

    query = from(item in Item, order_by: item.name)

    %{query: query}
  end

  describe "paginate/2" do
    test "returns first page with 10 entries when default options is given", %{query: query} do
      assert %Page{
               entries: entries,
               current_page: 1,
               page_size: 10,
               total_pages: 1
             } = Pages.paginate(query)

      assert Enum.count(entries) == 10

      assert [
               %Item{name: "a"} | _tail
             ] = entries
    end

    test "returns second page with 3 results", %{query: query} do
      opts = %{page: 2, page_size: 3}

      assert %Page{
               entries: entries,
               current_page: 2,
               page_size: 3,
               total_pages: 4
             } = Pages.paginate(query, opts)

      assert [
               %Item{name: "d"},
               %Item{name: "e"},
               %Item{name: "f"}
             ] = entries
    end

    test "returns last page with all lasting entries", %{query: query} do
      opts = %{page: 4, page_size: 3}

      assert %Page{
               entries: [%Item{name: "j"}],
               current_page: 4,
               page_size: 3,
               total_pages: 4
             } = Pages.paginate(query, opts)
    end

    test "returns empty page when exceeding total entries", %{query: query} do
      opts = %{page: 4, page_size: 5}

      assert %Page{
               entries: [],
               current_page: 4,
               page_size: 5,
               total_pages: 2
             } = Pages.paginate(query, opts)
    end

    test "returns default when page is smaller than 1", %{query: query} do
      opts = %{page: -1, page_size: 10}

      assert %Page{
               entries: entries,
               current_page: 1,
               page_size: 10,
               total_pages: 1
             } = Pages.paginate(query, opts)

      assert Enum.count(entries) == 10
    end

    test "returns default when page is not an integer", %{query: query} do
      opts = %{page: "asd", page_size: 1}

      assert %Page{
               entries: entries,
               current_page: 1,
               page_size: 10,
               total_pages: 1
             } = Pages.paginate(query, opts)

      assert Enum.count(entries) == 10
    end

    test "returns default when page_size is smaller than 1", %{query: query} do
      opts = %{page: 1, page_size: -1}

      assert %Page{
               entries: entries,
               current_page: 1,
               page_size: 10,
               total_pages: 1
             } = Pages.paginate(query, opts)

      assert Enum.count(entries) == 10
    end

    test "returns default when page_size is not an integer", %{query: query} do
      opts = %{page: 1, page_size: "asd"}

      assert %Page{
               entries: entries,
               current_page: 1,
               page_size: 10,
               total_pages: 1
             } = Pages.paginate(query, opts)

      assert Enum.count(entries) == 10
    end
  end
end
