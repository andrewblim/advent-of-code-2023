defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  test "problem1" do
    input = """
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
    """
    assert Day20.problem1(input, :io) == 32000000

    input2 = """
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
    """
    assert Day20.problem1(input2, :io) == 11687500
  end
end
