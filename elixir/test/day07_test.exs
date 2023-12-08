defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  test "problem1" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
    assert Day07.problem1(input, :io) == 6440
  end
end
