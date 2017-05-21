defmodule Optic.Ok do
  @moduledoc """
  {:ok, _} prism.
  """

  alias Optic.Element

  import Optic.Maybe, only: [just: 1, nothing: 0]

  @doc """
  Prism.

      iex> {:ok, 1} |> Optic.new |> Optic.Ok.ok |> Optic.get
      1

      iex> :error |> Optic.new |> Optic.Ok.ok |> Optic.get
      nil

      iex> {:ok, 1} |> Optic.new |> Optic.Ok.ok |> Optic.set(42)
      {:ok, 42}

      iex> :error |> Optic.new |> Optic.Ok.ok |> Optic.set(42)
      :error
  """
  @spec ok(Optic.t) :: Optoc.t
  def ok(optic) do
    e = Element.new %{
      getter: fn
        {:ok, y} -> just y
        _ -> nothing()
      end,
      setter: fn
        {:ok, _}, x -> {:ok, x}
        p, _ -> p
      end,
    }
    %{optic | elements: [e | optic.elements]}
  end
end
