defmodule Day15 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.replace("\n", "")
    |> String.split(",")
  end

  def hash(x) do
    for ch <- String.graphemes(x), reduce: 0 do
      acc ->
        <<value::utf8>> = ch
        rem((acc + value) * 17, 256)
    end
  end

  def apply_steps(steps) do
    # note, boxes come in reverse order
    init_boxes = for i <- 0..255, into: %{}, do: {i, []}
    for step <- steps, reduce: init_boxes do
      boxes ->
        if String.ends_with?(step, "-") do
          id = String.slice(step, 0, String.length(step) - 1)
          remove_lens(boxes, id)
        else
          [id, val] = String.split(step, "=")
          add_or_update_lens(boxes, id, String.to_integer(val))
        end
    end
  end

  def remove_lens(boxes, id) do
    box = hash(id)
    pos = Enum.find_index(Map.fetch!(boxes, box), fn {lens_id, _} -> lens_id == id end)
    if pos == nil do
      boxes
    else
      Map.update!(boxes, box, fn lenses -> List.delete_at(lenses, pos) end)
    end
  end

  def add_or_update_lens(boxes, id, val) do
    box = hash(id)
    pos = Enum.find_index(Map.fetch!(boxes, box), fn {lens_id, _} -> lens_id == id end)
    if pos == nil do
      Map.update!(boxes, box, fn lenses -> [{id, val} | lenses] end)
    else
      Map.update!(boxes, box, fn lenses -> List.replace_at(lenses, pos, {id, val}) end)
    end
  end

  def power(boxes) do
    for {box, lenses} <- boxes,
        {{_, focal_length}, slot_number} <- Enum.with_index(Enum.reverse(lenses), 1),
        reduce: 0 do
      acc ->
        acc + (1 + box) * slot_number * focal_length
    end
  end

  def problem1(input \\ "data/day15.txt", type \\ :file) do
    for x <- read_input(input, type), reduce: 0 do
      acc -> acc + hash(x)
    end
  end

  def problem2(input \\ "data/day15.txt", type \\ :file) do
    read_input(input, type)
    |> apply_steps()
    |> power()
  end
end
