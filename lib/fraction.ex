defmodule Fraction do
  defstruct a: nil, b: nil
  @type t() :: %Fraction{a: integer(), b: integer()}
  @spec new(integer(), integer()) :: %Fraction{a: integer(), b: integer()}
  def new(a, b), do: %Fraction{a: a, b: b}

  @spec value(Fraction.t()) :: float()
  def value(%Fraction{a: a, b: b}), do: a / b

  @spec add(Fraction.t(), Fraction.t()) :: %Fraction{a: integer(), b: integer()}
  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(a1 * b2 + a2 * b1, b1 * b2)
  end
end
