defmodule Day12.Part1 do
  def solve(input) do
    # We start fill_distances at 1 distance since the 0 start point
    # has already been set by input
    input |> parse_input() |> fill_distances(1) |> end_distance()
  end

  def parse_input(input) do
    state = %{elevations: %{}, distances: %{}, recents: [], end: nil}

    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(state, &parse_row/2)
  end

  def parse_row({row, y}, state) do
    row
    |> String.to_charlist()
    |> Enum.map(&parse_cell/1)
    |> Enum.with_index()
    |> Enum.reduce(state, &add_cell(&1, &2, y))
  end

  def parse_cell(char) do
    cond do
      char == hd('S') -> %{start?: true, end?: false, elevation: 0}
      char == hd('E') -> %{start?: false, end?: true, elevation: 25}
      true -> %{start?: false, end?: false, elevation: char - hd('a')}
    end
  end

  def add_cell({cell, x}, state, y) do
    point = {x, y}

    cond do
      cell.start? ->
        %{state | recents: [point]}
        |> set_distance(point, 0)
        |> set_elevation(point, cell.elevation)

      cell.end? ->
        %{state | end: point} |> set_elevation(point, cell.elevation)

      true ->
        state |> set_elevation(point, cell.elevation)
    end
  end

  def set_elevation(state, point, elevation) do
    %{state | elevations: Map.put(state.elevations, point, elevation)}
  end

  def set_distance(state, point, distance) do
    %{state | distances: Map.put(state.distances, point, distance)}
  end

  def fill_distances(%{recents: []} = state, _distance) do
    # Override fill distances recursion when recents is empty
    state
  end

  # Recursively set distances based on distances set in previous recursion
  def fill_distances(state, distance) do
    state.recents
    |> Enum.map(&next_neighbors(&1, state))
    |> List.flatten()
    |> Enum.uniq()
    |> set_distances(state, distance)
    |> fill_distances(distance + 1)
  end

  def next_neighbors(point, state) do
    next_elevation = state.elevations[point] + 1

    point
    |> neighbors()
    |> Enum.filter(fn neighbor -> state.distances[neighbor] == nil end)
    |> Enum.filter(fn neighbor -> state.elevations[neighbor] <= next_elevation end)
  end

  def neighbors(point) do
    {x, y} = point

    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  def end_distance(state) do
    state.distances[state.end]
  end

  def set_distances(points, state, distance) do
    points
    |> Enum.reduce(state, &set_distance(&2, &1, distance))
    |> Map.put(:recents, points)
  end
end

defmodule Day12.Part2 do
  def solve(input) do
    input
    |> Day12.Part1.parse_input()
    |> possible_starting_states()
    |> Enum.map(&solve_state/1)
    |> Enum.sort()
    |> List.first()
  end

  def solve_state(state) do
    # We start fill_distances at 1 distance since the 0 start point
    # has already been set by input
    state |> Day12.Part1.fill_distances(1) |> Day12.Part1.end_distance()
  end

  def possible_starting_states(state) do
    state.elevations |> Enum.filter(&lowest?/1) |> Enum.map(&change_start(&1, state))
  end

  def lowest?({_point, elevation}) do
    elevation == 0
  end

  def change_start({point, _elevation}, state) do
    %{state | recents: [point], distances: %{point => 0}}
  end
end

defmodule Mix.Tasks.Day12 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day12-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day12.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day12.Part2.solve(input))
  end
end
