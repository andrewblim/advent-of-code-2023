defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "problem1" do
    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """
    assert Day01.problem1(input, :io) == 142
  end

  test "problem2" do
    input = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
    assert Day01.problem2(input, :io) == 281
  end
end
