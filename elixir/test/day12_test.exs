defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "problem1" do
    input = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """
    assert Day12.problem1(input, :io) == 21
  end

  test "problem2" do
    input = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """
    assert Day12.problem2(input, :io) == 525152
  end
end
