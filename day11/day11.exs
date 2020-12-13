defmodule Util do
  def adjacent_occupied(seats, {x, y}) do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    |> Enum.count(fn {dx, dy} ->
      Map.get(seats, {x + dx, y + dy}) == "#"
    end)
  end

  def visible_occupied(seats, height, width, {x, y}) do
    [
      Stream.zip((x - 1)..min(x - 1, 0), (y - 1)..min(y - 1, 0)),
      Stream.map((x - 1)..min(x - 1, 0), &{&1, y}),
      Stream.zip((x - 1)..min(x - 1, 0), (y + 1)..max(y + 1, width)),
      Stream.map((y - 1)..min(y - 1, 0), &{x, &1}),
      Stream.map((y + 1)..max(y + 1, width), &{x, &1}),
      Stream.zip((x + 1)..max(x + 1, height), (y - 1)..min(y - 1, 0)),
      Stream.map((x + 1)..max(x + 1, height), &{&1, y}),
      Stream.zip((x + 1)..max(x + 1, height), (y + 1)..max(y + 1, width))
    ]
    |> Enum.count(fn s -> Enum.find_value(s, &Map.get(seats, &1)) == "#" end)
  end

  def iterate(seats, func, tolerance) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(seats, fn _, prev ->
      next =
        Map.keys(prev)
        |> Stream.map(fn k ->
          case {Map.get(prev, k), func.(prev, k)} do
            {"L", 0} -> {k, "#"}
            {"#", z} when z >= tolerance -> {k, "L"}
            {z, _} -> {k, z}
          end
        end)
        |> Map.new()

      if Map.equal?(next, prev) do
        {:halt, prev}
      else
        {:cont, next}
      end
    end)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end
end

seats =
  IO.stream(:stdio, :line)
  |> Stream.with_index()
  |> Enum.reduce(Map.new(), fn {row, x}, acc ->
    String.trim_trailing(row)
    |> String.graphemes()
    |> Stream.with_index()
    |> Enum.reduce(acc, fn {cell, y}, acc ->
      case cell do
        "." -> acc
        _ -> Map.put(acc, {x, y}, cell)
      end
    end)
  end)

Util.iterate(seats, &Util.adjacent_occupied(&1, &2), 4) |> IO.puts()

{height, width} =
  Map.keys(seats)
  |> Enum.reduce({0, 0}, fn {x, y}, {height, width} ->
    {max(x, height), max(y, width)}
  end)

Util.iterate(seats, &Util.visible_occupied(&1, height, width, &2), 5) |> IO.puts()
