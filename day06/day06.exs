defmodule Util do
  def mapset_operate(data, reducer) do
    Enum.map(data, &(Enum.reduce(&1, reducer) |> MapSet.size())) |> Enum.reduce(&(&1 + &2))
  end
end

data =
  IO.read(:stdio, :all)
  |> String.split(~r{\n\n})
  |> Enum.map(fn answers ->
    String.split(answers) |> Enum.map(&(String.graphemes(&1) |> MapSet.new()))
  end)

Util.mapset_operate(data, &MapSet.union(&1, &2)) |> IO.puts()
Util.mapset_operate(data, &MapSet.intersection(&1, &2)) |> IO.puts()
