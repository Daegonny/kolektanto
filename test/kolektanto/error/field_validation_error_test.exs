defmodule Kolektanto.Error.FieldValidationErrorTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Kolektanto.Error.FieldValidationError

  describe "build_from/1" do
    test "returns correct format" do
      changeset = %Ecto.Changeset{
        errors: [
          {:name,
           {
             "should be at least %{count} character(s)",
             [{:count, 10}, {:validation, :length}, {:kind, :min}, {:type, :string}]
           }},
          {:name,
           {"should be at least %{count} character(s)",
            [count: 50, validation: :length, kind: :min, type: :string]}},
          {:height,
           {"should be at least %{size} meters",
            [{:size, 10}, {:validation, :size}, {:kind, :min}, {:type, :number}]}}
        ]
      }

      assert [
               %FieldValidationError{
                 field: :height,
                 messages: ["should be at least 10 meters"]
               },
               %FieldValidationError{
                 field: :name,
                 messages: [
                   "should be at least 10 character(s)",
                   "should be at least 50 character(s)"
                 ]
               }
             ] = FieldValidationError.build_from(changeset)
    end
  end
end
