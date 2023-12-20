defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  test "problem1" do
    input = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
    assert Day15.problem1(input, :io) == 1320
  end

  test "problem2" do
    input = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
    assert Day15.problem2(input, :io) == 145
  end
end
