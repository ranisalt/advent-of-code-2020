defmodule Day1 do
  defp read_input() do
    IO.read(:stdio, :all)
    |> String.split()
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def main() do
    numbers =
      read_input()
      |> MapSet.new()

    {lower, upper} = Enum.split_with(numbers, fn x -> x < 1010 end)
    upper = MapSet.new(upper)

    x = Enum.find(lower, fn x -> MapSet.member?(upper, 2020 - x) end)
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
