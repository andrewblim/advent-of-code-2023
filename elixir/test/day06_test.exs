defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  test "problem1" do
    input = """
    Time:      7  15   30
    Distance:  9  40  200
    """
    assert Day06.problem1(input, :io) == 288
  end
end
