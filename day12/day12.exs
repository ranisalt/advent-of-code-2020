defmodule Util do
  def move({east, north}, dir, val) do
    case dir do
      "N" -> {east, north + val}
      "S" -> {east, north - val}
      "E" -> {east + val, north}
      "W" -> {east - val, north}
    end
  end

  def normalize_rotate(dir, val) do
    # normalize to rotr (rotl 90 = rotr 270)
    case dir do
      "L" -> rem(360 - val, 360)
      "R" -> val
    end
  end
end

steps =
  IO.stream(:stdio, :line)
  |> Enum.map(fn x ->
    {dir, val} = String.trim_trailing(x) |> String.split_at(1)
    {dir, String.to_integer(val)}
  end)

{{east, north}, _} =
  Enum.reduce(steps, {{0, 0}, "E"}, fn {dir, val}, {{east, north}, last_dir} ->
    case dir do
      "F" ->
        {Util.move({east, north}, last_dir, val), last_dir}

      x when x == "R" or x == "L" ->
        rval = Util.normalize_rotate(dir, val)

        [next_dir] =
          Stream.cycle(["E", "S", "W", "N"])
          |> Stream.drop_while(&(&1 != last_dir))
          |> Stream.drop(div(rval, 90))
          |> Enum.take(1)

        {{east, north}, next_dir}

      _ ->
        {Util.move({east, north}, dir, val), last_dir}
    end
  end)

(abs(east) + abs(north)) |> IO.puts()

{{east, north}, _} =
  Enum.reduce(steps, {{0, 0}, {10, 1}}, fn {dir, val}, {{sx, sy}, {wx, wy}} ->
    case dir do
      "F" ->
        {{sx + val * wx, sy + val * wy}, {wx, wy}}

      x when x == "R" or x == "L" ->
        rval = Util.normalize_rotate(dir, val)

        {x, y} = Enum.reduce(1..div(rval, 90), {wx, wy}, fn _, {x, y} -> {y, -x} end)
        {{sx, sy}, {x, y}}

      _ ->
        {{sx, sy}, Util.move({wx, wy}, dir, val)}
    end
  end)

(abs(east) + abs(north)) |> IO.puts()
