defmodule Day09 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.split() |> Enum.map(&String.to_integer/1)
    end)
  end

  def next_number(seq, acc \\ 0) do
    if Enum.all?(seq, fn x -> x == 0 end) do
      acc
    else
      next_seq = Enum.chunk_every(seq, 2, 1, :discard) |> Enum.map(fn [x, y] -> y - x end)
      next_number(next_seq, acc + List.last(seq))
    end
  end

  def next_number2(seq, acc \\ 0, factor \\ -1) do
    if Enum.all?(seq, fn x -> x == 0 end) do
      factor * acc
    else
      next_seq = Enum.chunk_every(seq, 2, 1, :discard) |> Enum.map(fn [x, y] -> y - x end)
      next_number2(next_seq, List.first(seq) - acc, -factor)
    end
  end

  def problem1(input \\ "data/day09.txt", type \\ :file) do
    values = read_input(input, type)
    values |> Enum.map(&next_number/1) |> Enum.sum()
  end

  def problem2(input \\ "data/day09.txt", type \\ :file) do
    values = read_input(input, type)
    values |> Enum.map(&next_number2/1) |> Enum.sum()
  end
end
