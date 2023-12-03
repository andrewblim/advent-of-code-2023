defmodule Day03 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
  end

  def is_blank?(ch) do
    ch == "."
  end

  def is_digit?(ch) do
    MapSet.member?(MapSet.new(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]), ch)
  end

  def is_symbol?(ch) do
    !is_blank?(ch) && !is_digit?(ch)
  end

  def is_gear?(ch) do
    ch == "*"
  end

  def generate_map(lines) do
    {map, _} =
      for {line, row} <- Enum.with_index(lines),
          line_length = String.length(line),
          {ch, col} <- Enum.with_index(String.graphemes(line)),
          reduce: {%{}, ""} do
            {map, current_number} ->
              cond do
                is_blank?(ch) && current_number != "" ->
                  {Map.put(map, {row, col - 1}, String.to_integer(current_number)), ""}
                is_blank?(ch) ->
                  {map, current_number}
                is_symbol?(ch) && current_number != "" ->
                  {
                    map
                    |> Map.put({row, col - 1}, String.to_integer(current_number))
                    |> Map.put({row, col}, ch),
                    ""
                  }
                is_symbol?(ch) ->
                  {Map.put(map, {row, col}, ch), ""}
                col == line_length - 1 ->
                  {Map.put(map, {row, col}, String.to_integer(current_number <> ch)), ""}
                true ->
                  {map, current_number <> ch}
              end
    end
    map
  end

  def score_part_numbers(map) do
    for {{row, col}, v} <- map,
        is_integer(v),
        part_number?(map, {row, col}),
        reduce: 0 do
      acc -> acc + v
    end
  end

  def part_number?(map, {row, col}) do
    n_digits = Integer.digits(Map.get(map, {row, col})) |> length()
    Enum.any?(
      for i <- (row - 1)..(row + 1),
          j <- (col - n_digits)..(col + 1),
          i != row || j == col - n_digits || j == col + 1 do
        is_symbol?(Map.get(map, {i, j}, "."))
      end
    )
  end

  def adjacent_gears_for_numbers(map) do
    for {{row, col}, v} <- map,
        is_integer(v),
        gear <- adjacent_gears(map, {row, col}),
        reduce: %{} do
      acc -> Map.update(acc, gear, [v], fn x -> [v | x] end)
    end
  end

  def adjacent_gears(map, {row, col}) do
    n_digits = Integer.digits(Map.get(map, {row, col})) |> length()
    for i <- (row - 1)..(row + 1),
        j <- (col - n_digits)..(col + 1),
        i != row || j == col - n_digits || j == col + 1,
        is_gear?(Map.get(map, {i, j}, ".")) do
      {i, j}
    end
  end

  def score_gears(gears) do
    for v <- Map.values(gears),
        length(v) == 2,
        reduce: 0 do
      acc -> acc + Enum.product(v)
    end
  end

  def problem1(input \\ "data/day03.txt", type \\ :file) do
    Day03.read_input(input, type)
    |> generate_map
    |> score_part_numbers()
  end

  def problem2(input \\ "data/day03.txt", type \\ :file) do
    Day03.read_input(input, type)
    |> generate_map
    |> adjacent_gears_for_numbers()
    |> score_gears()
  end
end
