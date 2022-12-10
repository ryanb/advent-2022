defmodule Day10.Part1 do
  def solve(input) do
    state = %{cycles: 0, register: 1, signals: [20, 60, 100, 140, 180, 220], signal_strengths: []}

    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(state, &run/2)
    |> Map.fetch!(:signal_strengths)
    |> Enum.sum()
  end

  def run(command, state) do
    if command == "noop" do
      state |> add_cycles(1) |> check_signal_strength()
    else
      [_, amount] = String.split(command, " ")

      state
      |> add_cycles(2)
      |> check_signal_strength()
      |> add_register(String.to_integer(amount))
    end
  end

  def add_cycles(state, amount) do
    %{state | cycles: state.cycles + amount}
  end

  def check_signal_strength(state) do
    if Enum.any?(state.signals) && hd(state.signals) <= state.cycles do
      strength = hd(state.signals) * state.register
      %{state | signals: tl(state.signals), signal_strengths: [strength | state.signal_strengths]}
    else
      state
    end
  end

  def add_register(state, amount) do
    %{state | register: state.register + amount}
  end
end

defmodule Day10.Part2 do
end

defmodule Mix.Tasks.Day10 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day10-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day10.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day10.Part2.solve(input))
  end
end
