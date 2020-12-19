[rules, [_ | raw_my], [_ | raw_nearby]] =
  IO.read(:stdio, :all)
  |> String.trim_trailing()
  |> String.split(~r/\n\n/)
  |> Enum.map(&String.split(&1, ~r/\n/))

ranges =
  Stream.map(rules, fn rule ->
    [field | boundaries] =
      Regex.run(~r/^(.+): (\d+)-(\d+) or (\d+)-(\d+)$/, rule, capture: :all_but_first)

    [first1, last1, first2, last2] = Enum.map(boundaries, &String.to_integer(&1))

    {field, [first1..last1, first2..last2]}
  end)
  |> Map.new()

only_ranges = Map.values(ranges) |> Stream.flat_map(& &1) |> Enum.sort()

nearby =
  Enum.map(raw_nearby, fn x ->
    String.split(x, ~r/,/) |> Enum.map(&String.to_integer(&1))
  end)

Stream.flat_map(nearby, & &1)
|> Stream.reject(fn x -> Enum.any?(only_ranges, &Enum.member?(&1, x)) end)
|> Enum.sum()
|> IO.puts()

only_keys = Map.keys(ranges) |> MapSet.new()
positions = hd(nearby) |> length()
init = Stream.repeatedly(fn -> only_keys end) |> Enum.take(positions)
my = hd(raw_my) |> String.split(~r/,/) |> Enum.map(&String.to_integer(&1))

Stream.reject(nearby, fn x ->
  Enum.map(x, fn value ->
    Enum.all?(only_ranges, &(not Enum.member?(&1, value)))
  end)
  |> Enum.any?()
end)
|> Stream.map(fn x ->
  Enum.map(x, fn value ->
    Enum.reduce(only_keys, [], fn key, acc ->
      if Map.get(ranges, key) |> Enum.any?(&Enum.member?(&1, value)) do
        [key | acc]
      else
        acc
      end
    end)
    |> MapSet.new()
  end)
end)
|> Enum.reduce(init, fn row, acc ->
  Stream.zip(acc, row) |> Enum.map(fn {x, y} -> MapSet.intersection(x, y) end)
end)
|> Stream.iterate(fn keys ->
  uniques = Stream.filter(keys, &(MapSet.size(&1) == 1)) |> Enum.reduce(&MapSet.union(&1, &2))

  Enum.map(keys, fn x ->
    case MapSet.size(x) do
      1 -> x
      _ -> MapSet.difference(x, uniques)
    end
  end)
end)
|> Stream.drop_while(fn x -> Enum.any?(x, &(MapSet.size(&1) != 1)) end)
|> Enum.take(1)
|> hd()
|> Stream.map(&(MapSet.to_list(&1) |> hd()))
|> Stream.with_index()
|> Stream.filter(fn {x, _} -> String.starts_with?(x, "departure") end)
|> Stream.map(fn {_, i} -> Enum.at(my, i) end)
|> Enum.reduce(&(&1 * &2))
|> IO.inspect()
