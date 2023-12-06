defmodule Day05 do
  def read_input(input, type \\ :file) do
    [seed_text | maps_text] =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n\n")
    seeds = seed_text |> String.split() |> Enum.drop(1) |> Enum.map(&String.to_integer/1)
    maps =
      for map_text <- maps_text,
          into: %{} do
        [description | numbers_text] = String.split(map_text, "\n")
        [_, from, to] = Regex.run(~r/^(\w+)\-to\-(\w+) map\:$/, description)
        numbers =
          for line <- numbers_text,
              [x, y, z] = Enum.map(String.split(line), &String.to_integer/1) do
            {x, y, z}
          end
        {from, {to, numbers}}
      end
    {seeds, maps}
  end

  def advance({state, values}, maps) do
    case Map.get(maps, state) do
      nil ->
        {state, values}
      {next_state, ranges} ->
        next_values = for val <- values, do: advance_value(val, ranges)
        advance({next_state, next_values}, maps)
    end
  end

  def advance_value(val, ranges) do
    case ranges do
      [] ->
        val
      [{dest_start, src_start, range_len} | _] when val >= src_start and val < src_start + range_len ->
        dest_start + val - src_start
      [_ | rest] ->
        advance_value(val, rest)
    end
  end

  def problem1(input \\ "data/day05.txt", type \\ :file) do
    {seeds, maps} = Day05.read_input(input, type)
    {"location", values} = advance({"seed", seeds}, maps)
    Enum.min(values)
  end

  def problem2(input \\ "data/day05.txt", type \\ :file) do
    {seeds, maps} = Day05.read_input(input, type)
    {"location", values} = advance({"seed", seeds}, maps)
    Enum.min(values)
  end
end
