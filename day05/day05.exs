use Bitwise

defmodule Util do
  def binsearch(tape, h, t) do
    {f, _} =
      String.graphemes(tape)
      |> Enum.reduce({0, 1 <<< String.length(tape)}, fn key, {x, y} ->
        diff = div(y - x, 2)

        case key do
          k when k == h -> {x, y - diff}
          k when k == t -> {x + diff, y}
        end
      end)

    f
  end
end

seats =
  IO.stream(:stdio, :line)
  |> Enum.map(fn x ->
    {row_rules, col_rules} = String.split_at(String.trim_trailing(x), 7)
    row = Util.binsearch(row_rules, "F", "B")
    col = Util.binsearch(col_rules, "L", "R")
    row * 8 + col
  end)
  |> MapSet.new()

max = Enum.max(seats) |> IO.inspect()

Enum.find(1..(max - 1), fn s ->
  Enum.member?(seats, s - 1) and Enum.member?(seats, s + 1) and not Enum.member?(seats, s)
end)
|> IO.puts()
