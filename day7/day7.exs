defmodule Day7 do
  defp dfs(rules, acc, node) do
    open =
      Map.get(rules, node, MapSet.new())
      |> MapSet.difference(acc)

    Enum.reduce(open, open, fn x, acc ->
      dfs(rules, acc, x)
      |> MapSet.union(acc)
    end)
    |> MapSet.union(acc)
  end

  def main() do
    IO.stream(:stdio, :line)
    |> Enum.reduce(Map.new(), fn x, acc ->
      [_, container, containees] = Regex.run(~r/^(.*) bags contain (.*)\.$/, x)

      String.split(containees, ", ")
      |> Enum.reduce(MapSet.new(), fn y, acc ->
        [_, amount, color] = Regex.run(~r/(no|\d+) (.*) bags?/, y)

        case amount do
          "no" -> acc
          _ -> MapSet.put(acc, color)
        end
      end)
      |> Enum.reduce(acc, fn y, acc ->
        new_value =
          Map.get(acc, y, MapSet.new())
          |> MapSet.put(container)

        Map.put(acc, y, new_value)
      end)
    end)
    |> dfs(MapSet.new(), "shiny gold")
    |> MapSet.size()
    |> IO.inspect()
  end
end

Day7.main()
