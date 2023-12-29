defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  test "problem1" do
    input = """
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    """
    assert Day21.problem1(input, :io, 6) == 16
  end
end
