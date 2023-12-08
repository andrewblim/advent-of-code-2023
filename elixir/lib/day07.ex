defmodule Day07 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
  end

  def parse_line(line) do
    [hand, bid] = String.split(line)
    {hand, String.to_integer(bid)}
  end

  def hand_type(hand) do
    counts = hand |> String.graphemes() |> Enum.frequencies() |> Map.values() |> Enum.sort()
    case counts do
      [5] -> 0
      [1, 4] -> 1
      [2, 3] -> 2
      [1, 1, 3] -> 3
      [1, 2, 2] -> 4
      [1, 1, 1, 2] -> 5
      _ -> 6
    end
  end

  def hand_value(hand) do
    rank_strength =
      ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
      |> Enum.with_index() |> Map.new()
    String.graphemes(hand) |> Enum.map(fn x -> Map.get(rank_strength, x) end)
  end

  def hand_type2(hand) do
    freqs = hand |> String.graphemes() |> Enum.frequencies()
    j_count = Map.get(freqs, "J", 0)
    non_j_counts = freqs |> Map.drop(["J"]) |> Map.values() |> Enum.sort()
    case {j_count, non_j_counts} do
      {0, [5]} -> 0
      {0, [1, 4]} -> 1
      {0, [2, 3]} -> 2
      {0, [1, 1, 3]} -> 3
      {0, [1, 2, 2]} -> 4
      {0, [1, 1, 1, 2]} -> 5
      {0, [1, 1, 1, 1, 1]} -> 6

      {1, [4]} -> 0
      {1, [1, 3]} -> 1
      {1, [2, 2]} -> 2
      {1, [1, 1, 2]} -> 3
      {1, [1, 1, 1, 1]} -> 5

      {2, [3]} -> 0
      {2, [1, 2]} -> 1
      {2, [1, 1, 1]} -> 3

      {3, [2]} -> 0
      {3, [1, 1]} -> 1

      {4, [1]} -> 0

      {5, []} -> 0
    end
  end

  def hand_value2(hand) do
    rank_strength =
      ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "1", "J"]
      |> Enum.with_index() |> Map.new()
    String.graphemes(hand) |> Enum.map(fn x -> Map.get(rank_strength, x) end)
  end

  def problem1(input \\ "data/day07.txt", type \\ :file) do
    data =
      for line <- Day07.read_input(input, type),
          {hand, bid} = parse_line(line) do
        {hand_type(hand), hand_value(hand), hand, bid}
      end
    data
    |> Enum.sort_by(fn {type, value, _, _} -> {type, value} end)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, _, _, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def problem2(input \\ "data/day07.txt", type \\ :file) do
    data =
      for line <- Day07.read_input(input, type),
          {hand, bid} = parse_line(line) do
        {hand_type2(hand), hand_value2(hand), hand, bid}
      end
    data
    |> Enum.sort_by(fn {type, value, _, _} -> {type, value} end)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, _, _, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end
end
