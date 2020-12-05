defmodule Day4 do
  defp required_fields(), do: MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

  def main() do
    IO.read(:stdio, :all)
    |> String.split(~r{\n\n})
    |> Enum.map(fn passport ->
      String.split(passport, ~r{\s+})
      |> Enum.sort()
    end)
    |> Enum.filter(fn passport ->
      keys =
        Enum.map(passport, fn field -> String.slice(field, 0..2) end)
        |> MapSet.new()

      MapSet.subset?(required_fields(), keys)
    end)
    |> Enum.count()
    |> IO.puts()
  end
end

Day4.main()
