defmodule Day8 do
  defp next_state(instructions, pc, acc, history) do
    next_history = MapSet.put(history, pc)
    {inst, imm} = Enum.at(instructions, pc)

    case inst do
      "acc" -> {pc + 1, acc + imm, next_history}
      "jmp" -> {pc + imm, acc, next_history}
      "nop" -> {pc + 1, acc, next_history}
    end
  end

  def try_exec(instructions, state) do
    # infinite loop with counter
    Enum.reduce_while(0..length(instructions), state, fn _, {pc, acc, history} ->
      if MapSet.member?(history, pc) do
        {:halt, acc}
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

try_exec(instructions, {0, 0, MapSet.new()}) |> IO.inspect()
