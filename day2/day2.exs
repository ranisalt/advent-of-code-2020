defmodule Day2 do
  def main() do
    re = ~r/(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<pwd>\w+)/

    rules =
      IO.stream(:stdio, :line)
      |> Enum.map(fn x ->
        captures = Regex.named_captures(re, x)
        min = String.to_integer(captures["min"])
        max = String.to_integer(captures["max"])

        {min, max, captures["char"], captures["pwd"]}
      end)

    rules
    |> Enum.count(fn {min, max, char, pwd} ->
      count =
        pwd
        |> String.graphemes()
        |> Enum.count(&(&1 == char))

      min <= count && count <= max
    end)
    |> IO.puts()

    rules
    |> Enum.count(fn {min, max, char, pwd} ->
      String.at(pwd, min - 1) == char != (String.at(pwd, max - 1) == char)
    end)
    |> IO.puts()
  end
end

Day2.main()
