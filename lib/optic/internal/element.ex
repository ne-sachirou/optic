defmodule Optic.Element do
  @moduledoc false

  alias Optic.Maybe

  import Maybe, only: [just: 1]

  defstruct getter: nil,
            setter: nil,
            mapper: nil

  @type t :: %__MODULE__{
    getter: (Optic.p -> Maybe.p(Optic.p)),
    setter: (Optic.p, term -> Optic.p),
    mapper: (Optic.p, (term -> term) -> Optic.p),
  } | (Optic.t -> Optic.t)

  @spec id() :: t
  def id, do: %__MODULE__{
    getter: fn p -> just p end,
    setter: fn _, x -> x end,
    mapper: fn p, fun -> fun.(p) end,
    # mapper: fn p, _ -> p end,
  }

  @spec new(map) :: t
  def new(e), do: Map.merge id(), e
end
