{_, _, mem} =
  IO.stream(:stdio, :line)
  |> Stream.map(&(String.trim_trailing(&1) |> String.split(~r/ = /, capture: :all_but_first)))
  |> Enum.reduce({0, 0, Map.new()}, fn [reg, val], {mask_set, mask_unset, mem} ->
    case reg do
      "mask" ->
        new_mask_set = String.replace(val, "X", "0") |> String.to_integer(2)
        new_mask_unset = String.replace(val, "X", "1") |> String.to_integer(2)
        {new_mask_set, new_mask_unset, mem}

      _ ->
        use Bitwise, only_operators: true
        pos_len = String.length(reg) - 5
        pos = String.slice(reg, 4, pos_len) |> String.to_integer()

        masked = (String.to_integer(val) ||| mask_set) &&& mask_unset
        {mask_set, mask_unset, Map.put(mem, pos, masked)}
    end
  end)

Map.values(mem) |> Enum.sum() |> IO.puts()
