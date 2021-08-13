[6, 3, 15, 13, 1, 0]
|> Enum.reverse
|> Stream.iterate(fn [last | state] ->
  found_at = state |> Enum.find_index(&(&1 == last))
  case found_at do
    nil ->
      [0, last | state]

    _ ->
      [found_at + 1, last | state]
  end
end)
|> Stream.drop_while(&(Enum.count(&1) < 2020))
|> Stream.take(1)
|> Enum.at(0)
|> Enum.at(0)
|> IO.inspect