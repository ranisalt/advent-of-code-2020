defmodule Day2 do
  def main() do
    re = ~r/(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pwd>\w+)/

    IO.stream(:stdio, :line)
    |> Enum.count(fn x ->
      captures = Regex.named_captures(re, x)

      count =
        captures["pwd"]
        |> String.graphemes()
        |> Enum.count(&(&1 == captures["char"]))

      String.to_integer(captures["min"]) <= count && count <= String.to_integer(captures["max"])
    end)
    |> IO.puts()
  end
end

Day2.main()
