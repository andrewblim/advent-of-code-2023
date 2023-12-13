defmodule Day10 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    for {line, row} <- Enum.with_index(lines),
        {ch, col} <- Enum.with_index(String.graphemes(line)),
        into: %{} do
      {{row, col}, ch}
    end
  end

  def count_steps(map, {row, col}, {prev_row, prev_col}, n) do
    case Map.get(map, {row, col}) do
      "S" -> n
      "-" ->
        cond do
          {row, col} == {prev_row, prev_col - 1} -> count_steps(map, {row, col - 1}, {row, col}, n + 1)
          {row, col} == {prev_row, prev_col + 1} -> count_steps(map, {row, col + 1}, {row, col}, n + 1)
        end
      "|" ->
        cond do
          {row, col} == {prev_row - 1, prev_col} -> count_steps(map, {row - 1, col}, {row, col}, n + 1)
          {row, col} == {prev_row + 1, prev_col} -> count_steps(map, {row + 1, col}, {row, col}, n + 1)
        end
      "L" ->
        cond do
          {row, col} == {prev_row + 1, prev_col} -> count_steps(map, {row, col + 1}, {row, col}, n + 1)
          {row, col} == {prev_row, prev_col - 1} -> count_steps(map, {row - 1, col}, {row, col}, n + 1)
        end
      "J" ->
        cond do
          {row, col} == {prev_row + 1, prev_col} -> count_steps(map, {row, col - 1}, {row, col}, n + 1)
          {row, col} == {prev_row, prev_col + 1} -> count_steps(map, {row - 1, col}, {row, col}, n + 1)
        end
      "7" ->
        cond do
          {row, col} == {prev_row - 1, prev_col} -> count_steps(map, {row, col - 1}, {row, col}, n + 1)
          {row, col} == {prev_row, prev_col + 1} -> count_steps(map, {row + 1, col}, {row, col}, n + 1)
        end
      "F" ->
        cond do
          {row, col} == {prev_row - 1, prev_col} -> count_steps(map, {row, col + 1}, {row, col}, n + 1)
          {row, col} == {prev_row, prev_col - 1} -> count_steps(map, {row + 1, col}, {row, col}, n + 1)
        end
    end
  end

  def count_steps_from_start(map) do
    with {{row, col}, "S"} <- Enum.find(map, fn {_, v} -> v == "S" end) do
      cond do
        Enum.member?(["|", "7", "F"], Map.get(map, {row - 1, col})) ->
          count_steps(map, {row - 1, col}, {row, col}, 1)
        Enum.member?(["|", "L", "J"], Map.get(map, {row + 1, col})) ->
          count_steps(map, {row + 1, col}, {row, col}, 1)
        Enum.member?(["-", "L", "F"], Map.get(map, {row, col - 1})) ->
          count_steps(map, {row, col - 1}, {row, col}, 1)
        Enum.member?(["-", "J", "7"], Map.get(map, {row, col + 1})) ->
          count_steps(map, {row, col + 1}, {row, col}, 1)
      end
    end
  end

  def problem1(input \\ "data/day10.txt", type \\ :file) do
    map = read_input(input, type)
    div(count_steps_from_start(map), 2)
  end
end
