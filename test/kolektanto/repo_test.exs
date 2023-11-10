defmodule Kolektanto.RepoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Kolektanto.Repo
  alias Kolektanto.Errors.FieldValidationError

  describe "normalize_result/1" do
    test "returns field validation error when error changeset is received" do
      changeset =
        %Ecto.Changeset{}
        |> Ecto.Changeset.add_error(:name, "error")

      assert {:error, :field_validation,
              [
                %FieldValidationError{
                  field: :name,
                  messages: ["error"]
                }
              ]} = Repo.normalize_result({:error, changeset})
    end

    test "returns error not found when nil is received" do
      assert {:error, :not_found} = Repo.normalize_result(nil)
    end

    test "propagates ok results" do
      assert {:ok, 10} = Repo.normalize_result({:ok, 10})
    end

    test "wraps results on ok tuples" do
      assert {:ok, 10} = Repo.normalize_result(10)
    end
  end
end
