defmodule CessTest do
  use ExUnit.Case
  doctest Cess

  test "greets the world" do
    assert Cess.hello() == :world
  end
end
