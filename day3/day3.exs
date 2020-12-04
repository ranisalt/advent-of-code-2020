defmodule Day3 do
  def main() do
    data =
      IO.stream(:stdio, :line)
      |> Enum.map(fn x -> String.trim_trailing(x) end)

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right, down} ->
      data
      |> Stream.take_every(down)
      |> Stream.with_index()
      |> Enum.count(fn {x, i} ->
        String.at(x, rem(i * right, String.length(x))) != "."
      end)
    end)
    |> Enum.reduce(fn el, acc -> el * acc end)
    |> IO.puts()
  end
end

Day3.main()
