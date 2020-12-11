defmodule Day3 do
  def main() do
    data = IO.stream(:stdio, :line) |> Enum.map(&String.trim_trailing(&1))

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right, down} ->
      Stream.take_every(data, down)
      |> Stream.with_index()
      |> Enum.count(fn {x, i} -> String.at(x, rem(i * right, String.length(x))) != "." end)
    end)
    |> Enum.reduce(&(&1 * &2))
    |> IO.puts()
  end
end

Day3.main()
