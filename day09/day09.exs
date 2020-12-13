defmodule Day9 do
  def main() do
    input =
      IO.stream(:stdio, :line) |> Enum.map(&(String.trim_trailing(&1) |> String.to_integer()))

    limit = 25
    preamble = Enum.take(input, limit)

    invalid =
      Enum.drop(input, limit)
      |> Enum.reduce_while(preamble, fn z, acc ->
        terms_in_preamble = Enum.any?(acc, fn x -> Enum.any?(acc, &(z == x + &1)) end)

        if terms_in_preamble do
          [_ | tail] = acc
          {:cont, tail ++ [z]}
        else
          {:halt, z}
        end
      end)
      |> IO.inspect()

    last = length(input) - 1

    Enum.find_value(0..last, fn i ->
      sum =
        Enum.find_value((i + 1)..last, fn j ->
          slice = Enum.slice(input, i..j)
          sum = Enum.sum(slice)

          cond do
            sum > invalid -> :halt
            sum == invalid -> Enum.min(slice) + Enum.max(slice)
            true -> nil
          end
        end)

      if sum != nil, do: sum
    end)
    |> IO.inspect()
  end
end

Day9.main()
