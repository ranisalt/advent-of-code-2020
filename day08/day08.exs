defmodule Util do
  defp next_state(instructions, pc, acc, history) do
    next_history = MapSet.put(history, pc)
    {inst, imm} = Enum.at(instructions, pc)

    case inst do
      "acc" -> {pc + 1, acc + imm, next_history}
      "jmp" -> {pc + imm, acc, next_history}
      "nop" -> {pc + 1, acc, next_history}
    end
  end

  def try_exec(instructions) do
    Enum.reduce_while(0..length(instructions), {0, 0, MapSet.new()}, fn _, {pc, acc, history} ->
      if MapSet.member?(history, pc) or pc == length(instructions) do
        {:halt, {pc, acc}}
      else
        {:cont, next_state(instructions, pc, acc, history)}
      end
    end)
  end
end

instructions =
  IO.stream(:stdio, :line)
  |> Enum.map(fn line ->
    [inst, imm] = Regex.run(~r/(\w+) ([+-]\d+)/, line, capture: :all_but_first)

    {inst, String.to_integer(imm)}
  end)

{_, acc} = Util.try_exec(instructions)
IO.puts(acc)

Stream.with_index(instructions)
|> Enum.find_value(fn {{inst, imm}, i} ->
  replacement =
    case inst do
      "jmp" -> "nop"
      "nop" -> "jmp"
      _ -> nil
    end

  if replacement do
    case List.replace_at(instructions, i, {replacement, imm}) |> Util.try_exec() do
      {pc, acc} when pc == length(instructions) -> acc
      _ -> nil
    end
  end
end)
|> IO.puts()
