defmodule TypedStructLegacyReflection do
  @moduledoc """
  TypedStructLegacyReflection is a
  [TypedStruct](https://github.com/ejpcmac/typed_struct) plugin defining the
  reflection functions that used to be built-in before TypedStruct 0.2.0.

  ## Setup

  To use this plugin in your project, add this to your Mix dependencies:

  ```elixir
  {:typed_struct_legacy_reflection, "~> #{Mix.Project.config()[:version]}"}
  ```

  If you do not plan to compile modules using this TypedStruct plugin at
  runtime, you can add `runtime: false` to the dependency tuple as it is only
  used during compilation.

  ## Usage

  To use this plugin in a typed struct, simply register it in the `typedstruct`
  block:

  ```elixir
  defmodule StructWithReflection do
    use TypedStruct

    typedstruct do
      plugin TypedStructLegacyReflection

      field :a_field, term()
      field :another_field, String.t()
    end
  end
  ```

  Three functions are then defined in your typed struct, like TypedStruct did in
  v0.1.x:

  * `__keys__/0` - returns the keys of the struct
  * `__defaults__/0` - returns the default value for each field
  * `__types__/0` - returns the quoted type for each field

  For instance:

  ```elixir
  iex(1)> defmodule Demo do
  ...(1)>   use TypedStruct
  ...(1)>
  ...(1)>   typedstruct do
  ...(1)>     plugin TypedStructLegacyReflection
  ...(1)>
  ...(1)>     field :a_field, String.t()
  ...(1)>     field :with_default, integer(), default: 7
  ...(1)>   end
  ...(1)> end
  {:module, Demo,
  <<70, 79, 82, 49, 0, 0, 8, 184, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 0, 241,
    0, 0, 0, 24, 11, 69, 108, 105, 120, 105, 114, 46, 68, 101, 109, 111, 8, 95,
    95, 105, 110, 102, 111, 95, 95, 7, 99, ...>>,
  [{TypedStructLegacyReflection, []}]}
  iex(2)> Demo.__keys__()
  [:a_field, :with_default]
  iex(3)> Demo.__defaults__()
  [a_field: nil, with_default: 7]
  iex(4)> Demo.__types__()
  [
    a_field: {:|, [],
    [
      {{:., [line: 7],
        [{:__aliases__, [counter: {Demo, 3}, line: 7], [:String]}, :t]},
        [line: 7], []},
      nil
    ]},
    with_default: {:integer, [line: 8], []}
  ]
  ```
  """

  use TypedStruct.Plugin

  @impl true
  @spec after_definition(keyword()) :: Macro.t()
  def after_definition(_opts) do
    quote do
      def __keys__, do: @ts_fields |> Keyword.keys() |> Enum.reverse()
      def __defaults__, do: Enum.reverse(@ts_fields)
      def __types__, do: Enum.reverse(@ts_types)
    end
  end
end
