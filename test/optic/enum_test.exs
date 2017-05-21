defmodule Optic.EnumTest do
  alias Optic.Enum, as: OEnum
  alias Optic.Tuple, as: OTuple

  use ExUnit.Case, async: true

  # doctest OEnum

  # describe "at/1" do
  #   test "at(0) |> at(1) |> get", do: assert [[1, 2], [3, 4]] |> Optic.new |> OEnum.at(0) |> OEnum.at(1) |> Optic.get == 2
  #   test "at(1) |> at(0) |> get", do: assert [[1, 2], [3, 4]] |> Optic.new |> OEnum.at(1) |> OEnum.at(0) |> Optic.get == 3
  #   test "at(0) |> at(1) |> set", do: assert [[1, 2], [3, 4]] |> Optic.new |> OEnum.at(0) |> OEnum.at(1) |> Optic.set(42) == [[1, 42], [3, 4]]
  #   test "at(1) |> at(0) |> set", do: assert [[1, 2], [3, 4]] |> Optic.new |> OEnum.at(1) |> OEnum.at(0) |> Optic.set(42) == [[1, 2], [42, 4]]
  #   test "at(0) |> at(1) |> map", do: assert [[1, 2], [3, 4]] |> Optic.new |> OEnum.at(0) |> OEnum.at(1) |> Optic.map(&(&1 + 1)) == [[1, 3], [3, 4]]
  #   test "at(1) |> at(0) |> map", do: assert [[1, 2], [3, 4]] |> Optic.new |> OEnum.at(1) |> OEnum.at(0) |> Optic.map(&(&1 + 1)) == [[1, 2], [4, 4]]
  # end

  # describe "filter/2" do
  #   test "filter |> get", do: assert 1..4 |> Optic.new |> OEnum.filter(&(rem(&1, 2) == 0)) |> Optic.get == [2, 4]
  #   test "filter |> set", do: assert 1..4 |> Optic.new |> OEnum.filter(&(rem(&1, 2) == 0)) |> Optic.set([42, 57]) == [1, 42, 3, 57]
  #   test "filter |> map", do: assert 1..4 |> Optic.new |> OEnum.filter(&(rem(&1, 2) == 0)) |> Optic.map(fn xs -> Enum.map xs, &(&1 + 1) end) == [1, 3, 3, 5]
  # end

  describe "each/1" do
    test "each |> get", do: assert [1, 2] |> Optic.new |> OEnum.each |> Optic.get == [1, 2]
    test "each |> set", do: assert [1, 2] |> Optic.new |> OEnum.each |> Optic.set(42) == [42, 42]
    test "each |> map", do: assert [1, 2] |> Optic.new |> OEnum.each |> Optic.map(fn x -> x + 1 end) == [2, 3]

    test "filter |> each |> get", do: assert [{1, "a"}, {2, "b"}, {3, "c"}, {4, "d"}]
    |> Optic.new
    |> OEnum.filter(fn {i, _} -> rem(i, 2) == 0 end)
    |> OEnum.each
    |> OTuple.at(1)
    |> Optic.get == ["b", "d"]

    test "filter |> each |> set", do: assert [{1, "a"}, {2, "b"}, {3, "c"}, {4, "d"}]
    |> Optic.new
    |> OEnum.filter(fn {i, _} -> rem(i, 2) == 0 end)
    |> OEnum.each
    |> OTuple.at(1)
    |> Optic.set("z") == [{1, "a"}, {2, "z"}, {3, "c"}, {4, "z"}]

    test "filter |> each |> map", do: assert [{1, "a"}, {2, "b"}, {3, "c"}, {4, "d"}]
    |> Optic.new
    |> OEnum.filter(fn {i, _} -> rem(i, 2) == 0 end)
    |> OEnum.each
    |> OTuple.at(1)
    # |> Optic.map(&(&1 <> "z")) == [{1, "a"}, {2, "bz"}, {3, "c"}, {4, "dz"}]
    |> Optic.map(&({&1, "z"})) == [{1, "a"}, {2, "bz"}, {3, "c"}, {4, "dz"}]
  end
end
