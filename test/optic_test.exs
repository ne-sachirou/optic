defmodule OpticTest do
  use ExUnit.Case, async: true

  doctest Optic

  # 1..4 |> Optic.new |> Optic.apply(fn _ -> [OEnum.at(0), OEnum.at(1)] end) |> OEnum.each |> OEnum.set(42) == [42, 42, 3, 4]
end
