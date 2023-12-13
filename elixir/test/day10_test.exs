defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "problem1" do
    input = """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """
    assert Day10.problem1(input, :io) == 4

    input2 = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
    assert Day10.problem1(input2, :io) == 8
  end
end
