defmodule Day1 do
  defp read_input() do
    IO.read(:stdio, :all)
    |> String.split()
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def main() do
    numbers = read_input()

    {lower, upper} = Enum.split_with(numbers, fn x -> x < 1010 end)

    {x, y} =
      Enum.find_value(for(i <- lower, j <- upper, do: {i, j}), fn {x, y} ->
        case x + y do
          2020 -> {x, y}
          _ -> nil
        end
      end)

    IO.puts(x * y)

    {x, y, z} =
      Enum.find_value(for(i <- numbers, j <- numbers, k <- numbers, do: {i, j, k}), fn {x, y, z} ->
        case x + y + z do
          2020 -> {x, y, z}
          _ -> nil
        end
      end)

    IO.puts(x * y * z)
  end
end

Day1.main()
