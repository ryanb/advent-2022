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
  @directions [:north, :east, :south, :west]

  def solve(input, scale) do
    input
    |> parse_input(scale)
    |> follow_commands()
    |> Day22.Part1.result()
  end

  def parse_input(input, scale) do
    [map_str, commands_str] = String.split(input, "\n\n", trim: true)
    map = parse_map(map_str, scale)
    commands = Day22.Part1.parse_commands(commands_str)
    {start_x, _} = :binary.match(map_str, ".")

    map
    |> Map.merge(%{
      faces: Day22.Part2.FacesBuilder.build_faces(map.minimap),
      commands: commands,
      position: {start_x, 0},
      direction: :east
    })
  end

  def parse_map(map_str, scale) do
    map = %{minimap: MapSet.new(), walls: MapSet.new(), scale: scale}

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
    minimap = MapSet.put(map.minimap, minimap_position({x, y}, map.scale))

    case tile do
      "#" -> %{map | minimap: minimap, walls: MapSet.put(map.walls, {x, y})}
      "." -> %{map | minimap: minimap}
      _ -> map
    end
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
      "R" -> Day22.Part1.turn(state, 1)
      "L" -> Day22.Part1.turn(state, -1)
      _ -> walk(state, String.to_integer(command))
    end
  end

  def walk(state, 0) do
    state
  end

  def walk(state, amount) do
    {position, direction} = walk_position_and_direction(state)

    if MapSet.member?(state.walls, position) do
      state
    else
      walk(%{state | position: position, direction: direction}, amount - 1)
    end
  end

  def walk_position_and_direction(state) do
    position = Day22.Part1.facing_position(state)

    if MapSet.member?(state.minimap, minimap_position(position, state.scale)) do
      {position, state.direction}
    else
      walk_with_wrap(state)
    end
  end

  def minimap_position({x, y}, scale) do
    {floor(x / scale), floor(y / scale)}
  end

  def direction_index(direction) do
    Enum.find_index(@directions, fn d -> d == direction end)
  end

  def walk_with_wrap(state) do
    mini_position = minimap_position(state.position, state.scale)

    next_mini_position = state.faces[mini_position] |> Enum.at(direction_index(state.direction))

    from_direction_index =
      state.faces[next_mini_position] |> Enum.find_index(fn p -> p == mini_position end)

    next_direction = Enum.at(@directions, rem(from_direction_index + 2, 4))

    offset = position_to_offset(state)

    {rx, ry} =
      offset_to_position(%{offset: offset, scale: state.scale, direction: next_direction})

    {mx, my} = next_mini_position
    next_position = {mx * state.scale + rx, my * state.scale + ry}

    {next_position, next_direction}
  end

  def position_to_offset(%{position: {x, y}, scale: scale, direction: direction}) do
    rx = rem(x, scale)
    ry = rem(y, scale)

    case direction do
      :north -> rx
      :east -> ry
      :south -> abs(scale - 1 - rx)
      :west -> abs(scale - 1 - ry)
    end
  end

  def offset_to_position(%{offset: offset, scale: scale, direction: direction}) do
    case direction do
      :north -> {offset, scale - 1}
      :east -> {0, offset}
      :south -> {abs(scale - 1 - offset), 0}
      :west -> {scale - 1, abs(scale - 1 - offset)}
    end
  end

  defmodule FacesBuilder do
    # The template is a map of faces to determine the neighbors
    # for the following pattern.
    #
    #  1
    # 025
    #  3
    #  4
    #
    @template %{
      0 => [1, 2, 3, 4],
      1 => [4, 5, 2, 0],
      2 => [1, 5, 3, 0],
      3 => [2, 5, 4, 0],
      4 => [3, 5, 1, 0],
      5 => [1, 4, 3, 2]
    }

    # This returns a map of positions to neighboring positions.
    # It is built by mapping the template to a list of intermediate
    # faces and mapping that to the final faces.
    # minimap is a set of {x, y} positions that occupy tiles.
    def build_faces(minimap) do
      intermediate_faces = build_intermediate_faces(minimap)

      intermediate_faces
      |> Map.values()
      |> Enum.reduce(%{}, &build_face(&1, &2, intermediate_faces))
    end

    def build_face(intermediate_face, faces, intermediate_faces) do
      neighbors =
        Enum.map(intermediate_face.neighbors, fn index ->
          intermediate_faces[index].position
        end)

      Map.put(faces, intermediate_face.position, neighbors)
    end

    # Intermediate faces is a map of indexes based on the template. The value of each is a map
    # with the following attributes.
    #
    #   position: the {x, y} position on the minimap.
    #   neighbors: A list of neighbor indexes starting from the north side and going clockwise.
    #
    def build_intermediate_faces(minimap) do
      position = MapSet.to_list(minimap) |> hd()

      expand_intermediate_faces(
        intermediate_faces: %{},
        minimap: minimap,
        index: 0,
        rotation: 0,
        position: position,
        from_position: nil
      )
    end

    def rotate_neighbors(neighbors, amount) do
      {last, first} = Enum.split(neighbors, rem(amount, length(neighbors)))
      first ++ last
    end

    def expand_intermediate_faces(
          intermediate_faces: intermediate_faces,
          minimap: minimap,
          index: index,
          rotation: rotation,
          position: position,
          from_position: from_position
        ) do
      neighbors = @template[index] |> rotate_neighbors(rotation)

      expanded_intermediate_faces =
        Map.put(intermediate_faces, index, %{position: position, neighbors: neighbors})

      [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
      |> Enum.with_index()
      |> Enum.reduce(expanded_intermediate_faces, fn {{rx, ry}, direction},
                                                     next_intermediate_faces ->
        {x, y} = position
        direction_position = {x + rx, y + ry}

        if direction_position == from_position || !Enum.member?(minimap, direction_position) do
          next_intermediate_faces
        else
          next_index = Enum.at(neighbors, direction)

          rotation =
            calculate_rotation(index: index, direction: direction, next_index: next_index)

          expand_intermediate_faces(
            intermediate_faces: next_intermediate_faces,
            minimap: minimap,
            index: next_index,
            rotation: rotation,
            position: direction_position,
            from_position: position
          )
        end
      end)
    end

    # The rotation is how the real face should be rotated in relation to the template face.
    # It is calculated by getting the difference of the directions we're coming from.
    # We add 2 to get the opposite direction so we are comparing the same side
    def calculate_rotation(index: index, direction: direction, next_index: next_index) do
      from_direction = Enum.find_index(@template[next_index], fn value -> value == index end)
      abs(from_direction + 2 - direction)
    end
  end
end

defmodule Mix.Tasks.Day22 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day22-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day22.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day22.Part2.solve(input, 50))
  end
end
