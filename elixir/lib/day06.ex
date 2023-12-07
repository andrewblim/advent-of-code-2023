defmodule Day06 do
  def read_input(input, type \\ :file) do
    [times_text, record_distances_text] =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")
    times = times_text |> String.split() |> Enum.drop(1) |> Enum.map(&String.to_integer/1)
    record_distances = record_distances_text |> String.split() |> Enum.drop(1) |> Enum.map(&String.to_integer/1)
    Enum.zip(times, record_distances)
  end

  def read_input2(input, type \\ :file) do
    [time_text, record_distance_text] =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")
    time = time_text |> String.replace(~r/[^\d]/, "") |> String.to_integer()
    record_distance = record_distance_text |> String.replace(~r/[^\d]/, "") |> String.to_integer()
    {time, record_distance}
  end

  def distance(time, init_hold) do
    init_hold * max(time - init_hold, 0)
  end

  def ways_to_win({time, record_distance}) do
    for init_hold <- 0..time,
        this_distance = distance(time, init_hold),
        this_distance > record_distance,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  def problem1(input \\ "data/day06.txt", type \\ :file) do
    races = Day06.read_input(input, type)
    races |> Enum.map(&ways_to_win/1) |> Enum.product()
  end

  def problem2(input \\ "data/day06.txt", type \\ :file) do
    race = Day06.read_input2(input, type)
    ways_to_win(race)
  end
end
