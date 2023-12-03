defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "problem1" do
    input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
    assert Day03.problem1(input, :io) == 4361
  end

  test "problem2" do
    input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
    assert Day03.problem2(input, :io) == 467835
  end
end
