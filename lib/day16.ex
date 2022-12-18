defmodule Day16.Part1 do
  @minutes 30

  # This produces the correct answer but it's a balance between accuracy and performance.
  # There is likely a better algorithm for a full accurate and performant solution.
  @branch_limit 10
  @search_depth 15

  def solve(input) do
    parse_input(input) |> set_distances_for_valves() |> highest_pressure()
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1) |> Map.new()
  end

  def parse_line(line) do
    regex = ~r/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.+)/
    [location, rate_str, joined_tunnels] = Regex.run(regex, line) |> tl()
    rate = String.to_integer(rate_str)
    tunnels = String.split(joined_tunnels, ", ")
    {location, %{rate: rate, tunnels: tunnels}}
  end

  def set_distances_for_valves(valves) do
    valves
    |> Enum.map(fn {location, valve} ->
      {location, Map.put(valve, :distances, distances_for_valve(location, valves))}
    end)
    |> Map.new()
  end

  def distances_for_valve(location, valves) do
    fill_distances(%{}, 0, [location], valves)
    |> Enum.reject(fn {location, _distance} -> valves[location].rate == 0 end)
    |> Map.new()
  end

  def fill_distances(distances, _distance, [], _valves) do
    distances
  end

  def fill_distances(distances, distance, locations, valves) do
    new_distances =
      locations
      |> Enum.reduce(distances, fn location, acc_distances ->
        if Map.has_key?(acc_distances, location) do
          acc_distances
        else
          Map.put(acc_distances, location, distance)
        end
      end)

    next_locations =
      locations
      |> Enum.flat_map(fn location -> valves[location].tunnels end)
      |> Enum.reject(fn location ->
        Map.has_key?(distances, location) || Enum.member?(locations, location)
      end)

    fill_distances(new_distances, distance + 1, next_locations, valves)
  end

  def highest_pressure(valves) do
    state = %{
      location: "AA",
      pressure: 0,
      open_valves: [],
      minutes: @minutes,
      valves: valves
    }

    find_best_state(state).pressure
  end

  def find_best_state(%{minutes: 0} = state) do
    state
  end

  def find_best_state(state) when state.minutes > 0 do
    # IO.inspect(
    #   Map.take(state, [:location, :minutes, :open_valves, :pressure, :potential_pressure])
    # )

    next_state = state |> fill_possible_states(@search_depth) |> next_best_state()

    if next_state do
      find_best_state(next_state)
    else
      state
    end
  end

  def next_best_state(state) do
    if Enum.any?(state.possible_states) do
      state.possible_states |> Enum.max_by(fn s -> s.potential_pressure end)
    end
  end

  def fill_possible_states(state, 0) do
    state
  end

  def fill_possible_states(state, depth) do
    states =
      state
      |> possible_states()
      |> Enum.sort_by(fn s -> s.potential_pressure end, :desc)
      |> Enum.take(@branch_limit)
      |> Enum.map(&fill_possible_states(&1, depth - 1))

    state |> Map.put(:possible_states, states) |> set_potential_pressure
  end

  def possible_states(state) do
    if Map.has_key?(state, :possible_states) do
      state.possible_states
    else
      locations = Map.keys(state.valves[state.location].distances) -- state.open_valves
      next_states = locations |> Enum.map(&next_state(state, &1)) |> Enum.reject(&is_nil/1)

      if Enum.any?(next_states) do
        next_states
      else
        # Include staying where you are as a possible state
        state |> pass_time(state.location) |> set_potential_pressure() |> List.wrap()
      end
    end
  end

  def set_potential_pressure(state) do
    if Map.has_key?(state, :possible_states) && Enum.any?(state.possible_states) do
      potential_pressure =
        state.possible_states
        |> Enum.map(fn s -> s.potential_pressure end)
        |> Enum.max()

      Map.put(state, :potential_pressure, potential_pressure)
    else
      Map.put(state, :potential_pressure, state.pressure + pressure_rate(state) * state.minutes)
    end
  end

  def next_state(state, new_location) do
    new_state = pass_time(state, new_location)

    if new_state.minutes > 0 do
      %{new_state | location: new_location, open_valves: [new_location | state.open_valves]}
      |> set_potential_pressure()
    end
  end

  def pass_time(state, new_location) do
    distance = state.valves[state.location].distances[new_location] || 0
    # extra 1 to open valve
    duration = distance + 1

    %{
      state
      | pressure: state.pressure + pressure_rate(state) * duration,
        minutes: state.minutes - duration
    }
  end

  def pressure_rate(state) do
    state.open_valves |> Enum.map(fn key -> state.valves[key].rate end) |> Enum.sum()
  end
end

defmodule Day16.Part2 do
end

defmodule Mix.Tasks.Day16 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day16-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day16.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day16.Part2.solve(input))
  end
end
