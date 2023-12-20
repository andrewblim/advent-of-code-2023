defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "problem1" do
    input = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    assert Day14.problem1(input, :io) == 136
  end

  test "problem2" do
    input = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    assert Day14.problem2(input, :io) == 64
  end
end
