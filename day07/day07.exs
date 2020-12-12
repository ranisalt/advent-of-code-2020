defmodule Day7 do
  defp contained_bags(rules, node) do
    Map.get(rules, node, MapSet.new())
    |> Stream.map(fn {color, amount} ->
      amount + amount * contained_bags(rules, color)
    end)
    |> Enum.sum()
  end

  defp outermost_color(rules, acc, node) do
    open = Map.get(rules, node, MapSet.new()) |> MapSet.difference(acc)

    Enum.reduce(open, open, &(outermost_color(rules, &2, &1) |> MapSet.union(&2)))
    |> MapSet.union(acc)
  end

  def main() do
    contains =
      IO.stream(:stdio, :line)
      |> Enum.reduce(Map.new(), fn x, acc ->
        [container, containees] =
          Regex.run(~r/^(.*) bags contain (.*)\.$/, x, capture: :all_but_first)

        contained =
          String.split(containees, ", ")
          |> Enum.reduce(MapSet.new(), fn y, acc ->
            [amount, color] = Regex.run(~r/(no|\d+) (.*) bags?/, y, capture: :all_but_first)

            case amount do
              "no" -> acc
              _ -> MapSet.put(acc, {color, String.to_integer(amount)})
            end
          end)

        Map.put(acc, container, contained)
      end)

    Enum.reduce(contains, Map.new(), fn {container, colors}, acc ->
      Enum.reduce(colors, acc, fn {y, _}, acc ->
        new_value = Map.get(acc, y, MapSet.new()) |> MapSet.put(container)

        Map.put(acc, y, new_value)
      end)
    end)
    |> outermost_color(MapSet.new(), "shiny gold")
    |> MapSet.size()
    |> IO.inspect()

    contained_bags(contains, "shiny gold") |> IO.inspect()
  end
end

Day7.main()
