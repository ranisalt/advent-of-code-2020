defmodule Day1 do
  def main() do
    numbers =
      IO.read(:stdio, :all) |> String.split() |> Enum.map(&String.to_integer(&1)) |> MapSet.new()

    {lower, upper} = Enum.split_with(numbers, &(&1 < 1010))
    upper = MapSet.new(upper)

    x = Enum.find(lower, &MapSet.member?(upper, 2020 - &1))
    y = 2020 - x
    IO.puts(x * y)

    {x, y} =
      Enum.find(for(i <- numbers, j <- numbers, do: {i, j}), fn {x, y} ->
        Enum.member?(numbers, 2020 - (x + y))
      end)

    z = 2020 - (x + y)
    IO.puts(x * y * z)
  end
end

Day1.main()
