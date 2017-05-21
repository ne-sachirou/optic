defmodule Optic.Maybe do
  @moduledoc """
  Maybe
  """

  @type t :: t(term)
  @type t(value) :: {:ok, value} | nil

  @doc """
  Just.

      iex> Optic.Maybe.just 1
      {:ok, 1}
  """
  @spec just(term) :: t
  def just(value), do: {:ok, value}

  @doc """
  Nothing.

      iex> Optic.Maybe.nothing
      nil
  """
  @spec nothing :: t
  def nothing, do: nil

  @doc """
  isJust.

      iex> Optic.Maybe.just? Optic.Maybe.just 1
      true

      iex> Optic.Maybe.just? Optic.Maybe.nothing
      false
  """
  @spec just?(t) :: boolean
  def just?({:ok, _}), do: true
  def just?(nil), do: false

  @doc """
  isNothing.

      iex> Optic.Maybe.nothing? Optic.Maybe.just 1
      false

      iex> Optic.Maybe.nothing? Optic.Maybe.nothing
      true
  """
  @spec nothing?(t) :: boolean
  def nothing?({:ok, _}), do: false
  def nothing?(nil), do: true

  @doc """
  Functor map.

      iex> 1 |> Optic.Maybe.just |> Optic.Maybe.map(&(&1 + 1))
      {:ok, 2}

      iex> Optic.Maybe.nothing |> Optic.Maybe.map(&(&1 + 1))
      nil
  """
  @spec map(t, (term -> term)) :: t
  def map({:ok, value}, fun), do: {:ok, fun.(value)}
  def map(nil, _), do: nil

  @doc """
  Applicative apply.

      iex> 1 |> Optic.Maybe.just |> Optic.Maybe.apply(Optic.Maybe.just &(&1 + 1))
      {:ok, 2}
  """
  @spec apply(t, t) :: t
  def apply({:ok, value}, {:ok, fun}), do: {:ok, fun.(value)}
  def apply(nil, _), do: nil
  def apply(_, nil), do: nil

  @doc """
  Monad flat_map.

      iex> 1 |> Optic.Maybe.just |> Optic.Maybe.flat_map(&(Optic.Maybe.just &1 + 1))
      {:ok, 2}
  """
  @spec flat_map(t, (term -> t)) :: t
  def flat_map({:ok, value}, fun), do: fun.(value)
  def flat_map(nil, _), do: nil

  @doc """
  fromMaybe.

      iex> 1 |> Optic.Maybe.just |> Optic.Maybe.get
      1

      iex> Optic.Maybe.nothing |> Optic.Maybe.get
      nil

      iex> 1 |> Optic.Maybe.just |> Optic.Maybe.get(42)
      1

      iex> Optic.Maybe.nothing |> Optic.Maybe.get(42)
      42
  """
  @spec get(t, term) :: term
  def get(maybe, default \\ nil)
  def get({:ok, value}, _), do: value
  def get(nil, value), do: value
end
