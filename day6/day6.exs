defmodule Day6 do
  defp mapset_operate(data, reducer) do
    Enum.map(data, fn answers ->
      Enum.reduce(answers, reducer)
      |> MapSet.size()
    end)
    |> Enum.reduce(fn x, acc -> acc + x end)
    |> IO.puts()
  end

  def main() do
    data =
      IO.read(:stdio, :all)
      |> String.split(~r{\n\n})
      |> Enum.map(fn answers ->
        String.split(answers)
        |> Enum.map(fn x ->
          String.graphemes(x)
          |> MapSet.new()
        end)
      end)

    mapset_operate(data, fn x, acc -> MapSet.union(x, acc) end)
    mapset_operate(data, fn x, acc -> MapSet.intersection(x, acc) end)
  end
end

Day6.main()
