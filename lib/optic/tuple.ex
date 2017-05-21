defmodule Optic.Tuple do
  @moduledoc """
  Tuple lens.
  """

  alias Optic.Element

  import Optic.Maybe, only: [just: 1]

  @doc """
  Lens.

      iex> {1, 2} |> Optic.new |> Optic.Tuple.at(0) |> Optic.get
      1

      iex> {1, 2} |> Optic.new |> Optic.Tuple.at(0) |> Optic.set(42)
      {42, 2}
  """
  @spec at(Optic.t, integer) :: Optic.t
  def at(optic, i) do
    e = Element.new %{
      getter: fn p when is_tuple(p) -> just elem(p, i) end,
      setter: fn p, x when is_tuple(p) -> put_elem p, i, x end,
    }
    %{optic | elements: [e | optic.elements]}
  end
end
