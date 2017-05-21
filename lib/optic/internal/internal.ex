defmodule Optic.Internal do
  @moduledoc false

  alias Optic.Element
  alias Optic.Maybe

  @spec compose(Optic.t) :: Element.t
  def compose(%{photon: photon, elements: [e | elements]} = optic) when is_function(e),
    do: compose(if Maybe.just?(photon), do: e.(%{optic | elements: elements}), else: id optic)
  # def compose(%{elements: [e]}), do: e
  def compose(%{photon: photon, elements: [e | elements]}) do
    photon = Maybe.flat_map photon, e.getter
    %{getter: getter, setter: setter, mapper: mapper} = compose %{photon: photon, elements: elements}
    Element.new %{
      getter: fn _ -> Maybe.flat_map photon, getter end,
      setter: fn p, x ->
        x = photon |> Maybe.apply(Maybe.just(&(setter.(&1, x)))) |> Maybe.get
        e.setter.(p, x)
      end,
      mapper: fn p, fun ->
        # e.mapper.(mapper.(p, &(&1)), fun)
        # e.mapper.(mapper.(p, fun), &(&1))
        mapper.(e.mapper.(p, fun), &(&1))
      end
    }
  end
  def compose(%{elements: []} = optic), do: id optic

  @spec id(Optic.t) :: Optic.e
  defp id(%{photon: photon}), do: Element.new %{getter: fn _ -> photon end}
end
