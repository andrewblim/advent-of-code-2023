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

  def traverse(map, {row, col}, {prev_row, prev_col}, visited \\ []) do
    case Map.get(map, {row, col}) do
      "S" -> visited
      "-" ->
        cond do
          {row, col} == {prev_row, prev_col - 1} -> traverse(map, {row, col - 1}, {row, col}, [{row, col} | visited])
          {row, col} == {prev_row, prev_col + 1} -> traverse(map, {row, col + 1}, {row, col}, [{row, col} | visited])
        end
      "|" ->
        cond do
          {row, col} == {prev_row - 1, prev_col} -> traverse(map, {row - 1, col}, {row, col}, [{row, col} | visited])
          {row, col} == {prev_row + 1, prev_col} -> traverse(map, {row + 1, col}, {row, col}, [{row, col} | visited])
        end
      "L" ->
        cond do
          {row, col} == {prev_row + 1, prev_col} -> traverse(map, {row, col + 1}, {row, col}, [{row, col} | visited])
          {row, col} == {prev_row, prev_col - 1} -> traverse(map, {row - 1, col}, {row, col}, [{row, col} | visited])
        end
      "J" ->
        cond do
          {row, col} == {prev_row + 1, prev_col} -> traverse(map, {row, col - 1}, {row, col}, [{row, col} | visited])
          {row, col} == {prev_row, prev_col + 1} -> traverse(map, {row - 1, col}, {row, col}, [{row, col} | visited])
        end
      "7" ->
        cond do
          {row, col} == {prev_row - 1, prev_col} -> traverse(map, {row, col - 1}, {row, col}, [{row, col} | visited])
          {row, col} == {prev_row, prev_col + 1} -> traverse(map, {row + 1, col}, {row, col}, [{row, col} | visited])
        end
      "F" ->
        cond do
          {row, col} == {prev_row - 1, prev_col} -> traverse(map, {row, col + 1}, {row, col}, [{row, col} | visited])
          {row, col} == {prev_row, prev_col - 1} -> traverse(map, {row + 1, col}, {row, col}, [{row, col} | visited])
        end
    end
  end

  def get_start(map) do
    Enum.find(map, fn {_, v} -> v == "S" end) |> elem(0)
  end

  def traverse_from_start(map) do
    {row, col} = get_start(map)
    cond do
      Enum.member?(["|", "7", "F"], Map.get(map, {row - 1, col})) ->
        traverse(map, {row - 1, col}, {row, col}, [{row, col}])
      Enum.member?(["|", "L", "J"], Map.get(map, {row + 1, col})) ->
        traverse(map, {row + 1, col}, {row, col}, [{row, col}])
      Enum.member?(["-", "L", "F"], Map.get(map, {row, col - 1})) ->
        traverse(map, {row, col - 1}, {row, col}, [{row, col}])
      Enum.member?(["-", "J", "7"], Map.get(map, {row, col + 1})) ->
        traverse(map, {row, col + 1}, {row, col}, [{row, col}])
    end
  end

  def assign_start(map, visited) do
    {finish_row, finish_col} = hd(visited)
    [{start_row, start_col}, {second_row, second_col} | _] = Enum.reverse(visited)
    gap1 = {start_row - finish_row, start_col - finish_col}
    gap2 = {second_row - start_row, second_col - start_col}
    start_value = case {gap1, gap2} do
      {{-1, 0}, {-1, 0}} -> "|"
      {{-1, 0}, {0, -1}} -> "7"
      {{-1, 0}, {0, 1}} -> "F"

      {{1, 0}, {1, 0}} -> "|"
      {{1, 0}, {0, -1}} -> "J"
      {{1, 0}, {0, 1}} -> "L"

      {{0, -1}, {0, -1}} -> "-"
      {{0, -1}, {-1, 0}} -> "L"
      {{0, -1}, {1, 0}} -> "F"

      {{0, 1}, {0, 1}} -> "-"
      {{0, 1}, {-1, 0}} -> "J"
      {{0, 1}, {1, 0}} -> "7"
    end
    Map.put(map, {start_row, start_col}, start_value)
  end

  def get_sides({row, col}, {next_row, next_col}, map) do
    # returns {left, right} in direction of travel
    # start by assuming we're going from the lower value to the higher value, flip if needed
    {adj1, adj2, flip?} = case Map.get(map, {row, col}) do
      "|" -> {[{row, col + 1}], [{row, col - 1}], row > next_row}
      "-" -> {[{row - 1, col}], [{row + 1, col}], col > next_col}
      "L" -> {[], [{row, col - 1}, {row + 1, col}], row > next_row}
      "J" -> {[{row, col + 1}, {row + 1, col}], [], row > next_row}
      "7" -> {[{row - 1, col}, {row, col + 1}], [], col > next_col}
      "F" -> {[], [{row - 1, col}, {row, col - 1}], col < next_col}
    end
    if flip?, do: {adj2, adj1}, else: {adj1, adj2}
  end

  def mark_pipe_and_sides(map, visited) do
    pipe = MapSet.new(visited)
    point_pairs = [List.last(visited) | visited] |> Enum.chunk_every(2, 1, :discard)
    {left, right} = for [point, next_point] <- point_pairs, reduce: {MapSet.new(), MapSet.new()} do
      {left, right} ->
        {new_left, new_right} = get_sides(point, next_point, map)
        {
          new_left |> MapSet.new() |> MapSet.union(left),
          new_right |> MapSet.new() |> MapSet.union(right),
        }
    end
    {pipe, MapSet.difference(left, pipe), MapSet.difference(right, pipe)}
  end

  def fill_side(pipe, side, max_row, max_col) do
    if at_edge?(side, max_row, max_col) do
      {:outer, side}
    else
      next_side =
        for {row, col} <- side,
            adj <- [{row - 1, col}, {row, col - 1}, {row, col + 1}, {row + 1, col}],
            not MapSet.member?(pipe, adj),
            into: side do
          adj
        end
      if side == next_side do
        {:inner, side}
      else
        fill_side(pipe, next_side, max_row, max_col)
      end
    end
  end

  def at_edge?(side, max_row, max_col) do
    side |> Enum.any?(fn {row, col} ->
      row <= 0 or col <= 0 or row >= max_row or col >= max_col
    end)
  end

  def find_inner_side(pipe, left, right, max_row, max_col) do
    case fill_side(pipe, left, max_row, max_col) do
      {:inner, side} -> side
      _ -> case fill_side(pipe, right, max_row, max_col) do
        {:inner, side} -> side
      end
    end
  end

  def problem1(input \\ "data/day10.txt", type \\ :file) do
    map = read_input(input, type)
    traverse_from_start(map) |> length() |> div(2)
  end

  def problem2(input \\ "data/day10.txt", type \\ :file) do
    map = read_input(input, type)
    visited = traverse_from_start(map)
    map = assign_start(map, visited)
    {pipe, left, right} = mark_pipe_and_sides(map, visited)
    {max_row, max_col} = map |> Map.keys() |> Enum.max()
    find_inner_side(pipe, left, right, max_row, max_col) |> MapSet.size()
  end
end
