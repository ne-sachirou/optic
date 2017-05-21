defmodule Optic do
  @moduledoc """
  Optic: Lens, Prism, Traversal, Iso.
  """

  alias Optic.Element
  alias Optic.Internal
  alias Optic.Maybe

  @type p :: term
  @type t :: %__MODULE__{
    photon: Maybe.t(p),
    elements: [Element.t],
  }

  defstruct photon: {}, elements: []

  @doc """
  Make a new optic.

      iex> Optic.new
      %Optic{elements: [], photon: nil}

      iex> Optic.new []
      %Optic{elements: [], photon: {:ok, []}}
  """
  @spec new :: t
  def new, do: %__MODULE__{photon: Maybe.nothing}
  @spec new(p) :: t
  def new(photon), do: %__MODULE__{photon: Maybe.just photon}

  @doc """
  Switch the optic of the photon.

      iex> Optic.new |> Optic.of([])
      %Optic{elements: [], photon: {:ok, []}}
  """
  @spec of(t, p) :: t
  def of(optic, photon), do: %{optic | photon: Maybe.just photon}

  @doc """
  Execute the getter.

      iex> Optic.new |> Optic.get
      nil

      iex> Optic.new([]) |> Optic.get
      []
  """
  @spec get(t) :: term
  def get(%{photon: photon} = optic) do
    %{getter: getter} = reverse_compose optic
    photon |> Maybe.flat_map(getter) |> Maybe.get
  end

  @doc """
  Execute the setter.

      iex> Optic.new |> Optic.set({})
      nil

      iex> Optic.new([]) |> Optic.set({})
      {}
  """
  @spec set(t, term) :: p
  def set(p, x), do: map p, fn _ -> x end

  @doc """
      iex> Optic.new(1) |> Optic.map(&(&1 + 1))
      2

      iex> Optic.new |> Optic.map(&(&1 + 1))
      nil
  """
  @spec map(t, (term -> term)) :: p
  def map(%{photon: photon} = optic, fun) do
    %{getter: getter, setter: setter, mapper: mapper} = reverse_compose optic
    x = photon |> Maybe.flat_map(getter) |> Maybe.map(fn p -> mapper.(p, fun) end) |> Maybe.get
    photon |> Maybe.map(&(setter.(&1, x))) |> Maybe.get(Maybe.get(photon))
  end

  @spec reverse_compose(t) :: Element.t
  defp reverse_compose(%{elements: elements} = optic),
    do: Internal.compose %{optic | elements: Enum.reverse elements}
end
