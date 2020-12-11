defmodule Day6 do
  defp mapset_operate(data, reducer) do
    Enum.map(data, fn answers ->
      Enum.reduce(answers, reducer)
      |> MapSet.size()
    end)
    |> Enum.reduce(&(&1 + &2))
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

    mapset_operate(data, &MapSet.union(&1, &2))
    mapset_operate(data, &MapSet.intersection(&1, &2))
  end
end

Day6.main()
