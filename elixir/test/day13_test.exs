defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "problem1" do
    input = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """
    assert Day13.problem1(input, :io) == 405
  end
end
