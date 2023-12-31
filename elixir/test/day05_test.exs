defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "problem1" do
    input = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """
    assert Day05.problem1(input, :io) == 35
  end

  test "compress_ranges" do
    assert Day05.compress_ranges([1..10, 2..9]) == [1..10]
    assert Day05.compress_ranges([1..10, 2..11]) == [1..11]
    assert Day05.compress_ranges([1..10, 101..110]) == [1..10, 101..110]
    assert Day05.compress_ranges([1..10, 2..9, 101..110]) == [1..10, 101..110]
    assert Day05.compress_ranges([1..10, 2..11, 101..110]) == [1..11, 101..110]
  end

  test "problem2" do
    input = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """
    assert Day05.problem2(input, :io) == 46
  end
end
