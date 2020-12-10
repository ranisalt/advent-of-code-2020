defmodule Day10 do
  def main() do
    input =
      IO.stream(:stdio, :line)
      |> Stream.map(fn x -> String.trim_trailing(x) |> String.to_integer() end)
      |> Enum.sort()

    {_, diff1, diff3} =
      Enum.reduce(input, {0, 0, 1}, fn curr, {last, diff1, diff3} ->
        case curr - last do
          1 -> {curr, diff1 + 1, diff3}
          3 -> {curr, diff1, diff3 + 1}
        end
      end)

    IO.inspect(diff1 * diff3)
  end
end

Day10.main()
