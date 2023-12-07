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
      {next_state, transitions} ->
        next_values = for val <- values, do: advance_single_value(val, transitions)
        advance({next_state, next_values}, maps)
    end
  end

  def advance_single_value(val, transitions) do
    case transitions do
      [] ->
        val
      [{dest_start, src_start, range_len} | _] when val >= src_start and val < src_start + range_len ->
        dest_start + val - src_start
      [_ | rest] ->
        advance_single_value(val, rest)
    end
  end

  def advance_ranges({state, ranges}, maps) do
    ranges = compress_ranges(ranges)
    case Map.get(maps, state) do
      nil ->
        {state, ranges}
      {next_state, transitions} ->
        next_ranges = apply_transitions(transitions, ranges)
        advance_ranges({next_state, next_ranges}, maps)
    end
  end

  def apply_transitions(transitions, ranges, next_ranges \\ []) do
    case transitions do
      [] ->
        ranges ++ next_ranges
      [{dest_start, src_start, range_len} | rest] ->
        {remove_ranges, remainder_ranges} = remove_from_ranges(src_start..(src_start + range_len - 1), ranges)
        transitioned_ranges = for x..y <- remove_ranges, do: (x + dest_start - src_start)..(y + dest_start - src_start)
        apply_transitions(rest, remainder_ranges, transitioned_ranges ++ next_ranges)
    end
  end

  def remove_from_ranges(x..y, ranges) do
    for range <- ranges,
        reduce: {[], []} do
      {remove_ranges, remainder_ranges} ->
        intersection = range_intersection(x..y, range)
        case intersection do
          nil ->
            {remove_ranges, [range | remainder_ranges]}
          ix..iy ->
            remainders = range_subtraction(range, ix..iy)
            {[intersection | remove_ranges], remainders ++ remainder_ranges}
        end
    end
  end

  def range_intersection(x1..y1, x2..y2) do
    x = max(x1, x2)
    y = min(y1, y2)
    if x <= y, do: x..y
  end

  def range_subtraction(x1..y1, x2..y2) do
    cond do
      x1 == x2 and y1 == y2 -> []
      x1 < x2 and y1 > y2 -> [x1..(x2 - 1), (y2 + 1)..y1]
      x1 < x2 -> [x1..(x2 - 1)]
      true -> [(y2 + 1)..y1]
    end
  end

  def compress_ranges(ranges) do
    # assuming only positive numbers
    case Enum.sort(ranges) do
      [] -> []
      [init_range | rest_ranges] ->
        for range <- rest_ranges, reduce: [init_range] do
          [head_x..head_y | rest] ->
            case range do
              x..y when x > head_y -> [x..y | [head_x..head_y | rest]]
              _..y when y > head_y -> [head_x..y | rest]
              _ -> [head_x..head_y | rest]
            end
        end
        |> Enum.reverse()
    end
  end

  def problem1(input \\ "data/day05.txt", type \\ :file) do
    {seeds, maps} = Day05.read_input(input, type)
    {"location", values} = advance({"seed", seeds}, maps)
    Enum.min(values)
  end

  def problem2(input \\ "data/day05.txt", type \\ :file) do
    {seeds, maps} = Day05.read_input(input, type)
    ranges = Enum.chunk_every(seeds, 2) |> Enum.map(fn [x, y] -> x..(x + y - 1) end)
    {"location", [x.._ | _]} = advance_ranges({"seed", ranges}, maps)
    x
  end
end
