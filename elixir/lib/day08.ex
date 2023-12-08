defmodule Day08 do
  def read_input(input, type \\ :file) do
    [instructions, paths_text] =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n\n")
    paths =
      for line <- String.split(paths_text, "\n") do
        [_, from, left, right] = Regex.run(~r/^(\w+) = \((\w+), (\w+)\)$/, line)
        {from, left, right}
      end
    {instructions, paths}
  end

  def make_map(paths) do
    for {from, left, right} <- paths, into: %{}, do: {from, {left, right}}
  end

  def move(start, map, step) do
    {l, r} = Map.get(map, start)
    case step do
      "L" -> l
      "R" -> r
    end
  end

  def move_until(start, target, map, instructions) do
    Enum.reduce_while(
      Stream.cycle(String.graphemes(instructions)),
      {start, 0},
      fn step, {current, i} ->
        if current == target do
          {:halt, i}
        else
          {:cont, {move(current, map, step), i + 1}}
        end
      end
    )
  end

  def problem1(input \\ "data/day08.txt", type \\ :file) do
    {instructions, paths} = read_input(input, type)
    map = make_map(paths)
    move_until("AAA", "ZZZ", map, instructions)
  end
end
