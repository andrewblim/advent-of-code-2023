defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "problem1" do
    input = ~S"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """
    assert Day16.problem1(input, :io) == 46
  end
end
