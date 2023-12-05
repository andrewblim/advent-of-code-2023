defmodule Day04 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
  end

  def parse_line(line) do
    [_, id_text, winners_text, draw_text] = Regex.run(~r/^Card\s+(\d+)\: (.*) \| (.*)$/, line)
    winners = for x <- String.split(winners_text), do: String.to_integer(x)
    draw = for x <- String.split(draw_text), do: String.to_integer(x)
    {String.to_integer(id_text), winners, draw}
  end

  def count_winners(winners, draw) do
    MapSet.intersection(MapSet.new(winners), MapSet.new(draw)) |> MapSet.size()
  end

  def card_count(card_map) do
    init_count = for id <- Map.keys(card_map), into: %{}, do: {id, 1}
    for id <- Enum.sort(Map.keys(card_map)),
        {winners, draw} = Map.get(card_map, id),
        n_winners = count_winners(winners, draw),
        n_winners > 0,
        i <- (id + 1)..(id + n_winners),
        i <= Enum.max(Map.keys(card_map)),
        reduce: init_count do
      acc ->
        n_cards = Map.get(acc, id)
        Map.update!(acc, i, fn n -> n + n_cards end)
    end
  end

  def problem1(input \\ "data/day04.txt", type \\ :file) do
    for line <- Day04.read_input(input, type),
        {_, winners, draw} = parse_line(line),
        n_winners = count_winners(winners, draw),
        reduce: 0 do
      acc -> acc + if n_winners == 0, do: 0, else: Integer.pow(2, n_winners - 1)
    end
  end

  def problem2(input \\ "data/day04.txt", type \\ :file) do
    card_map =
      for line <- Day04.read_input(input, type),
          {id, winners, draw} = parse_line(line),
          into: %{} do
        {id, {winners, draw}}
      end
    for n <- Map.values(card_count(card_map)), reduce: 0 do
      acc -> acc + n
    end
  end
end
