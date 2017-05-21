defmodule Optic.Enum do
  @moduledoc """
  Enum lens, traversal.
  """

  alias Optic.Element
  alias Optic.Internal
  alias Optic.Maybe

  import Maybe, only: [just: 1, nothing: 0, nothing?: 1]

  @doc """
  Enum.at/2 lens.

      iex> [1, 2] |> Optic.new |> Optic.Enum.at(0) |> Optic.get
      1

      iex> [1, 2] |> Optic.new |> Optic.Enum.at(0) |> Optic.set(42)
      [42, 2]
  """
  @spec at(Optic.t, integer) :: Optic.t
  def at(optic, i) do
    e = Element.new %{
      getter: fn p -> just Enum.at(p, i) end,
      setter: fn p, x -> p |> Enum.with_index |> Enum.map(fn {value, j} -> if i == j, do: x, else: value end) end,
    }
    %{optic | elements: [e | optic.elements]}
  end

  @doc """
  Enum.filter/2 lens.

      iex> 1..4 |> Optic.new |> Optic.Enum.filter(&(rem(&1, 2) == 0)) |> Optic.get
      [2, 4]

      iex> 1..4 |> Optic.new |> Optic.Enum.filter(&(rem(&1, 2) == 0)) |> Optic.set([42, 57])
      [1, 42, 3, 57]
  """
  @spec filter(Optic.t, (term -> boolean)) :: Optic.t
  def filter(optic, fun) do
    e = fn %{photon: p, elements: elements} = optic ->
      p = Maybe.get p
      {values, indexes} = p |> Enum.with_index |> Enum.filter(fn {value, _} -> fun.(value) end) |> Enum.unzip
      e = Element.new %{
        getter: fn _ -> just values end,
        setter: fn _, x ->
          p
          |> Enum.with_index
          |> Enum.map_reduce(
            {indexes, x},
            fn
              {value, _}, {[], []} -> {value, {[], []}}
              {value, i}, {indexes, x} ->
                if hd(indexes) == i do
                  {hd(x), {tl(indexes), tl(x)}}
                else
                  {value, {indexes, x}}
                end
            end
          )
          |> elem(0)
        end
      }
      %{optic | elements: [e | elements]}
    end
    %{optic | elements: [e | optic.elements]}
  end

  @doc """
  Enum.each/2 traversal.

      iex> [{1, "a"}, {2, "b"}] |> Optic.new |> Optic.Enum.each |> Optic.Tuple.at(1) |> Optic.get
      ["a", "b"]

      iex> [{1, "a"}, {2, "b"}] |> Optic.new |> Optic.Enum.each |> Optic.Tuple.at(0) |> Optic.set(:ok)
      [{:ok, "a"}, {:ok, "b"}]
  """
  @spec each(Optic.t) :: Optic.t
  def each(optic) do
    e = fn %{photon: p, elements: elements} = optic ->
      p = Maybe.get p
      elements = p |> Enum.map(fn x -> Internal.compose %Optic{photon: just(x), elements: elements} end)
      e = Element.new %{
        getter: fn _ ->
          values = elements |> Enum.map(&(&1.getter.(p)))
          if Enum.any?(values, &(nothing? &1)), do: nothing(), else: values |> Enum.map(&(Maybe.get &1)) |> just
        end,
        setter: fn p, x ->
          IO.inspect {:x, x}
          [elements, p, x]
          |> Enum.zip
          |> Enum.map(fn {%{setter: setter}, p, x} -> setter.(p, x) end)
        end,
        mapper: fn p, fun ->
          IO.inspect {:p, p}
          Enum.map p, fun
        end
      }
      %{optic | elements: [e]}
    end
    %{optic | elements: [e | optic.elements]}
  end
end
