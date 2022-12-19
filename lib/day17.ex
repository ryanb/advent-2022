defmodule Day17.Part1 do
  @width 7
  @spawn_x 2
  @spawn_y 3
  @rock_limit 2022
  @rocks [
    # Minus
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],

    # Plus
    [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}],

    # Backwards L
    [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}],

    # Pipe
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],

    # Square
    [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
  ]

  def solve(input) do
    input
    |> parse_jet_pattern()
    |> build_state()
    |> take_turns()
    |> Map.fetch!(:blocks)
    |> height()
  end

  def build_state(jet_pattern) do
    %{
      jet_pattern: jet_pattern,
      next_jets: jet_pattern,
      blocks: MapSet.new(),
      rock_count: 0,
      rock: nil
    }
    |> spawn_rock()
  end

  def take_turns(state) do
    if state.rock_count > @rock_limit do
      state
    else
      state |> take_turn() |> take_turns()
    end
  end

  def take_turn(state) do
    state |> jet_push() |> fall()
  end

  def parse_jet_pattern(pattern_str) do
    pattern_str
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(fn char ->
      case char do
        ?< -> :left
        ?> -> :right
        _ -> throw("Unknown char #{char}")
      end
    end)
  end

  def jet_push(state) do
    direction =
      if hd(state.next_jets) == :left do
        -1
      else
        1
      end

    new_rock = move_rock(state.rock, direction, 0)

    if colliding?(state.blocks, new_rock) do
      state |> cycle_jet
    else
      %{state | rock: new_rock} |> cycle_jet
    end
  end

  def cycle_jet(state) do
    if tl(state.next_jets) == [] do
      %{state | next_jets: state.jet_pattern}
    else
      %{state | next_jets: tl(state.next_jets)}
    end
  end

  def fall(state) do
    new_rock = move_rock(state.rock, 0, -1)

    if colliding?(state.blocks, new_rock) do
      settle(state) |> spawn_rock()
    else
      %{state | rock: new_rock}
    end
  end

  def move_rock(rock, x1, y1) do
    Enum.map(rock, fn {x2, y2} -> {x1 + x2, y1 + y2} end)
  end

  def settle(state) do
    %{state | blocks: MapSet.union(state.blocks, MapSet.new(state.rock))}
  end

  def spawn_rock(state) do
    index = rem(state.rock_count, length(@rocks))
    spawn_y = height(state.blocks) + @spawn_y
    rock = @rocks |> Enum.at(index) |> move_rock(@spawn_x, spawn_y)
    %{state | rock: rock, rock_count: state.rock_count + 1}
  end

  def height(blocks) when blocks == %MapSet{}, do: 0

  def height(blocks) do
    blocks |> Enum.map(fn {_x, y} -> y end) |> Enum.max() |> Kernel.+(1)
  end

  def colliding?(blocks, rock) do
    Enum.any?(rock, fn {x, y} = point ->
      x < 0 || x >= @width || y < 0 || Enum.member?(blocks, point)
    end)
  end
end

defmodule Day17.Part2 do
end

defmodule Mix.Tasks.Day17 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day17-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day17.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day17.Part2.solve(input))
  end
end
