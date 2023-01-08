defmodule Day22.Part1 do
  @directions [:east, :south, :west, :north]
  # This is the amount to jump when determining the wrap position.
  # It should be no bigger than the smallest gap, otherwise it might jump the gap.
  @wrap_jump 16
  @y_multiplier 1000
  @x_multiplier 4

  def solve(input) do
    input
    |> parse_input()
    |> follow_commands()
    |> result()
  end

  def parse_input(input) do
    [map_str, commands_str] = String.split(input, "\n\n", trim: true)
    map = parse_map(map_str)
    commands = parse_commands(commands_str)
    {start_x, _} = :binary.match(map_str, ".")
    map |> Map.merge(%{commands: commands, position: {start_x, 0}, direction: :east})
  end

  def parse_map(map_str) do
    map = %{tiles: MapSet.new(), walls: MapSet.new()}

    map_str
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(map, &parse_map_line/2)
  end

  def parse_map_line({line, y}, map) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, &parse_map_tile(&1, y, &2))
  end

  def parse_map_tile({tile, x}, y, map) do
    case tile do
      "#" -> %{map | tiles: MapSet.put(map.tiles, {x, y}), walls: MapSet.put(map.walls, {x, y})}
      "." -> %{map | tiles: MapSet.put(map.tiles, {x, y})}
      _ -> map
    end
  end

  def parse_commands(commands_str) do
    Regex.scan(~r/(R|L|\d+)/, commands_str, capture: :first) |> List.flatten()
  end

  def follow_commands(%{commands: []} = state) do
    state
  end

  def follow_commands(state) do
    next_state = follow_command(state)
    follow_commands(%{next_state | commands: tl(state.commands)})
  end

  def follow_command(state) do
    command = hd(state.commands)

    case command do
      "R" -> turn(state, 1)
      "L" -> turn(state, -1)
      _ -> walk(state, String.to_integer(command))
    end
  end

  def turn(state, amount) do
    index = rem(direction_index(state.direction) + amount, length(@directions))
    %{state | direction: Enum.at(@directions, index)}
  end

  def walk(state, 0) do
    state
  end

  def walk(state, amount) do
    position = walk_position(state)

    if MapSet.member?(state.walls, position) do
      state
    else
      walk(%{state | position: position}, amount - 1)
    end
  end

  def walk_position(state) do
    position = facing_position(state)

    if MapSet.member?(state.tiles, position) do
      position
    else
      wrap_position(state)
    end
  end

  def facing_position(state) do
    {x, y} = state.position
    {x_offset, y_offset} = direction_offset(state.direction, 1)
    {x + x_offset, y + y_offset}
  end

  def direction_offset(direction, amount) do
    case direction do
      :east -> {1 * amount, 0}
      :west -> {-1 * amount, 0}
      :south -> {0, 1 * amount}
      :north -> {0, -1 * amount}
      _ -> throw("Unknown direction: #{inspect(direction)}")
    end
  end

  def wrap_position(state) do
    opposite_direction = Enum.at(@directions, direction_index(state.direction) - 2)
    offset = direction_offset(opposite_direction, @wrap_jump)
    find_wrap_position(state, state.position, offset)
  end

  def direction_index(direction) do
    Enum.find_index(@directions, fn d -> d == direction end)
  end

  def find_wrap_position(_state, position, {0, 0}) do
    position
  end

  def find_wrap_position(state, {x, y} = position, {x_offset, y_offset} = position_offset) do
    new_position = {x + x_offset, y + y_offset}

    if MapSet.member?(state.tiles, new_position) do
      find_wrap_position(state, new_position, position_offset)
    else
      cond do
        x_offset == -1 -> position
        x_offset == 1 -> position
        y_offset == -1 -> position
        y_offset == 1 -> position
        true -> find_wrap_position(state, position, {floor(x_offset / 2), floor(y_offset / 2)})
      end
    end
  end

  def result(state) do
    {x, y} = state.position
    (x + 1) * @x_multiplier + (y + 1) * @y_multiplier + direction_index(state.direction)
  end
end

defmodule Day22.Part2 do
end

defmodule Mix.Tasks.Day22 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day22-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day22.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day22.Part2.solve(input))
  end
end
