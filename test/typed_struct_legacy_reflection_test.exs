defmodule TypedStructLegacyReflectionTest do
  use ExUnit.Case

  ############################################################################
  ##                               Test data                                ##
  ############################################################################

  defmodule TestStruct do
    use TypedStruct

    typedstruct do
      plugin TypedStructLegacyReflection

      field :int, integer()
      field :string, String.t()
      field :string_with_default, String.t(), default: "default"
      field :mandatory_int, integer(), enforce: true
    end
  end

  ############################################################################
  ##                             Standard cases                             ##
  ############################################################################

  test "generates a function to get the struct keys" do
    assert TestStruct.__keys__() == [
             :int,
             :string,
             :string_with_default,
             :mandatory_int
           ]
  end

  test "generates a function to get the struct defaults" do
    assert TestStruct.__defaults__() == [
             int: nil,
             string: nil,
             string_with_default: "default",
             mandatory_int: nil
           ]
  end

  test "generates a function to get the struct types" do
    types =
      quote do
        [
          int: integer() | nil,
          string: String.t() | nil,
          string_with_default: String.t(),
          mandatory_int: integer()
        ]
      end

    assert delete_context(TestStruct.__types__()) == delete_context(types)
  end

  ############################################################################
  ##                                Helpers                                 ##
  ############################################################################

  # Deletes the context from a quoted expression.
  defp delete_context(list) when is_list(list),
    do: Enum.map(list, &delete_context/1)

  defp delete_context({a, b}),
    do: {delete_context(a), delete_context(b)}

  defp delete_context({fun, _context, args}),
    do: {delete_context(fun), [], delete_context(args)}

  defp delete_context(other), do: other
end
