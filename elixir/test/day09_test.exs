defmodule Day09Test do
  use ExUnit.Case
  doctest Day09

  test "problem1" do
    input = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """
    assert Day09.problem1(input, :io) == 114
  end

  test "problem2" do
    input = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """
    assert Day09.problem2(input, :io) == 2
  end
end
