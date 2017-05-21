defmodule Optic.TupleTest do
  alias Optic.Tuple, as: OTuple

  use ExUnit.Case, async: true

  doctest OTuple

  describe "at/2" do
    test "at(0) |> at(1) |> get", do: assert {{1, 2}, {3, 4}} |> Optic.new |> OTuple.at(0) |> OTuple.at(1) |> Optic.get == 2
    test "at(0) |> at(1) |> set", do: assert {{1, 2}, {3, 4}} |> Optic.new |> OTuple.at(0) |> OTuple.at(1) |> Optic.set(42) == {{1, 42}, {3, 4}}
    test "at(0) |> at(1) |> map", do: assert {{1, 2}, {3, 4}} |> Optic.new |> OTuple.at(0) |> OTuple.at(1) |> Optic.map(&(&1 + 1)) == {{1, 3}, {3, 4}}
    test "at(1) |> at(0) |> get", do: assert {{1, 2}, {3, 4}} |> Optic.new |> OTuple.at(1) |> OTuple.at(0) |> Optic.get == 3
    test "at(1) |> at(0) |> set", do: assert {{1, 2}, {3, 4}} |> Optic.new |> OTuple.at(1) |> OTuple.at(0) |> Optic.set(42) == {{1, 2}, {42, 4}}
    test "at(1) |> at(0) |> map", do: assert {{1, 2}, {3, 4}} |> Optic.new |> OTuple.at(1) |> OTuple.at(0) |> Optic.map(&(&1 + 1)) == {{1, 2}, {4, 4}}
  end
end
