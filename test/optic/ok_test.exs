defmodule Optic.OkTest do
  import Optic.Ok, only: [ok: 1]

  use ExUnit.Case, async: true

  doctest Optic.Ok

  describe "ok/1" do
    test ":ok |> ok |> get", do: assert {:ok, 1} |> Optic.new |> ok |> Optic.get == 1
    test ":error |> ok |> get", do: assert :error |> Optic.new |> ok |> Optic.get == nil
    test ":ok |> ok |> set", do: assert {:ok, 1} |> Optic.new |> ok |> Optic.set(42) == {:ok, 42}
    test ":error |> ok |> set", do: assert :error |> Optic.new |> ok |> Optic.set(42) == :error
    test ":ok |> ok |> map", do: assert {:ok, 1} |> Optic.new |> ok |> Optic.map(&(&1 + 1)) == {:ok, 2}
    test ":error |> ok |> map", do: assert :error |> Optic.new |> ok |> Optic.map(&(&1 + 1)) == :error
  end
end
