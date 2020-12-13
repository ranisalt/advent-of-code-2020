defmodule Util do
  defp is_valid_hgt(value) do
    {num, unit} = String.split_at(value, -2)

    case unit do
      "cm" -> Enum.member?(150..193, String.to_integer(num))
      "in" -> Enum.member?(59..76, String.to_integer(num))
      _ -> false
    end
  end

  defp valid_eye_colors(), do: MapSet.new(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

  def is_valid_passport(passport) do
    Enum.all?(passport, fn field ->
      {key, value} = String.split_at(field, 4)

      case String.slice(key, 0..2) do
        "byr" ->
          Enum.member?(1920..2002, String.to_integer(value))

        "iyr" ->
          Enum.member?(2010..2020, String.to_integer(value))

        "eyr" ->
          Enum.member?(2020..2030, String.to_integer(value))

        "hgt" ->
          is_valid_hgt(value)

        "hcl" ->
          String.match?(value, ~r/^#[0-9a-f]{6}$/)

        "ecl" ->
          Enum.member?(valid_eye_colors(), value)

        "pid" ->
          String.match?(value, ~r/^\d{9}$/)

        "cid" ->
          true
      end
    end)
  end
end

required_fields = MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
data = IO.read(:stdio, :all) |> String.split(~r{\n\n})

passports_with_required_fields =
  Enum.map(data, &(String.split(String.trim_trailing(&1), ~r{\s+}) |> Enum.sort()))
  |> Enum.filter(fn passport ->
    keys = Enum.map(passport, &String.slice(&1, 0..2)) |> MapSet.new()

    MapSet.subset?(required_fields, keys)
  end)

length(passports_with_required_fields) |> IO.puts()
Enum.count(passports_with_required_fields, &Util.is_valid_passport(&1)) |> IO.puts()
