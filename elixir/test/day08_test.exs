defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  test "problem1" do
    input = """
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """
    assert Day08.problem1(input, :io) == 2

    input2 = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """
    assert Day08.problem1(input2, :io) == 6
  end
end
