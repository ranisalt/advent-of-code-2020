use Bitwise

defmodule Day5 do
  defp binsearch(tape, h, t) do
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

  def main() do
    seats =
      IO.stream(:stdio, :line)
      |> Enum.map(fn x ->
        {row_rules, col_rules} = String.split_at(String.trim_trailing(x), 7)
        row = binsearch(row_rules, "F", "B")
        col = binsearch(col_rules, "L", "R")
        row * 8 + col
      end)
      |> MapSet.new()

    max = Enum.max(seats)
    IO.puts(max)

    Enum.find(1..max - 1, fn seat ->
      Enum.member?(seats, seat - 1) and
        Enum.member?(seats, seat + 1) and
        not Enum.member?(seats, seat)
    end)
    |> IO.puts()
  end
end

Day5.main()
