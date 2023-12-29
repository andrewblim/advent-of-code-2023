defmodule Day21 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    for {line, row} <- Enum.with_index(lines),
        {ch, col} <- Enum.with_index(String.graphemes(line)),
        ch != ".",
        into: %{} do
      {{row, col}, ch}
    end
  end

  def step(map, positions, i) do
    case i do
      0 -> positions
      _ ->
        next_positions =
          for {r, c} <- positions,
              neighbor <- [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}],
              Map.get(map, neighbor) != "#",
              into: MapSet.new() do
            neighbor
          end
        step(map, next_positions, i - 1)
    end
  end

  def problem1(input \\ "data/day21.txt", type \\ :file, n \\ 64) do
    map = read_input(input, type)
    start = Enum.find(map, fn {_, v} -> v == "S" end) |> elem(0)
    step(map, MapSet.new([start]), n) |> MapSet.size()
  end

  def problem2(input \\ "data/day21.txt", type \\ :file) do
    read_input(input, type)
  end
end
