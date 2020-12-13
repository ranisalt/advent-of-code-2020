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
  count = String.graphemes(pwd) |> Enum.count(&(&1 == char))

  min <= count and count <= max
end)
|> IO.puts()

Enum.count(rules, fn {min, max, char, pwd} ->
  String.at(pwd, min - 1) == char != (String.at(pwd, max - 1) == char)
end)
|> IO.puts()
