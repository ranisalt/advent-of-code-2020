defmodule Day13 do
  defp euclid(a, b), do: euclid(abs(a), abs(b), 1, 0, 0, 1)
  defp euclid(last_rem, 0, last_x, _, _, _), do: {last_rem, last_x}

  defp euclid(last_rem, r, last_x, x, last_y, y) do
    quot = div(last_rem, r)
    next_rem = rem(last_rem, r)
    euclid(r, next_rem, x, last_x - quot * x, y, last_y - quot * y)
  end

  defp invmod(e, et) do
    {g, x} = euclid(e, et)
    if g != 1, do: raise("unexpected")
    rem(x + et, et)
  end

  def main() do
    departure = IO.read(:stdio, :line) |> String.trim_trailing() |> String.to_integer()

    lines =
      IO.read(:stdio, :line)
      |> String.trim_trailing()
      |> String.split(",")
      |> Enum.map(fn x ->
        case x do
          "x" -> nil
          _ -> String.to_integer(x)
        end
      end)

    {wait, id} =
      Stream.filter(lines, &(&1 != nil))
      |> Stream.map(&{&1 - rem(departure, &1), &1})
      |> Enum.min()

    IO.puts(wait * id)

    equations = Stream.with_index(lines) |> Enum.filter(fn {mod, _} -> mod != nil end)
    max = Enum.reduce(equations, 1, fn {n, _}, acc -> n * acc end)

    Stream.map(equations, fn {m, r} -> div(-r * max * invmod(div(max, m), m), m) end)
    |> Enum.sum()
    |> Integer.mod(max)
    |> IO.inspect()
  end
end

Day13.main()
