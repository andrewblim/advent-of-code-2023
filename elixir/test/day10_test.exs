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

    input3 = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """
    assert Day10.problem1(input3, :io) == 8
  end

  test "problem2" do
    input = """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """
    assert Day10.problem2(input, :io) == 1

    input2 = """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """
    assert Day10.problem2(input2, :io) == 4

    input3 = """
    ..........
    .S------7.
    .|F----7|.
    .||OOOO||.
    .||OOOO||.
    .|L-7F-J|.
    .|II||II|.
    .L--JL--J.
    ..........
    """
    assert Day10.problem2(input3, :io) == 4

    input4 = """
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """
    assert Day10.problem2(input4, :io) == 8

    input5 = """
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """
    assert Day10.problem2(input5, :io) == 10
  end
end
