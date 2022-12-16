defmodule Day15.Part1 do
  @y_target 2_000_000

  def solve(input, y_target \\ @y_target) do
    input |> parse_input() |> count_coverage(y_target)
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    regex = ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/
    [x1, y1, x2, y2] = Regex.run(regex, line) |> tl() |> Enum.map(&String.to_integer/1)
    %{sensor: {x1, y1}, beacon: {x2, y2}, distance: distance({x1, y1}, {x2, y2})}
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def count_coverage(sensors, y) do
    sensors
    |> Enum.map(&x_range(&1, y))
    |> Enum.reject(&is_nil/1)
    |> union_ranges()
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
    |> Kernel.-(count_beacons(y, sensors))
  end

  def count_beacons(y, sensors) do
    sensors
    |> Enum.map(fn sensor -> sensor.beacon end)
    |> Enum.uniq()
    |> Enum.count(fn {_x, by} -> by == y end)
  end

  def x_range(sensor, y) do
    %{sensor: {sx, sy}, distance: distance} = sensor
    length = distance - abs(y - sy)

    if length >= 0 do
      (sx - length)..(sx + length)
    end
  end

  def union_ranges(given_ranges) do
    given_ranges
    |> Enum.sort_by(fn first.._ -> first end)
    |> Enum.reduce([], fn range, ranges ->
      cond do
        ranges == [] ->
          [range]

        Range.disjoint?(range, hd(ranges)) ->
          [range | ranges]

        true ->
          first1..last1 = range
          first2..last2 = hd(ranges)
          [min(first1, first2)..max(last1, last2) | tl(ranges)]
      end
    end)
  end
end

defmodule Day15.Part2 do
  @size 4_000_000

  def solve(input, size \\ @size) do
    input
    |> Day15.Part1.parse_input()
    |> uncovered_point(size)
    |> tuning_signal()
  end

  def uncovered_point(sensors, size) do
    0..size |> Enum.find_value(&uncovered_point_for_y(&1, sensors, size))
  end

  def uncovered_point_for_y(y, sensors, size) do
    x =
      sensors
      |> Enum.map(&Day15.Part1.x_range(&1, y))
      |> Enum.reject(&is_nil/1)
      |> Enum.sort_by(fn first.._ -> first end)
      |> uncovered_x_for_ranges(-1)

    if x && x <= size do
      {x, y}
    end
  end

  def uncovered_x_for_ranges([], _last) do
    nil
  end

  def uncovered_x_for_ranges([r1..r2 | ranges], last) do
    if last + 1 < r1 do
      last + 1
    else
      uncovered_x_for_ranges(ranges, max(r2, last))
    end
  end

  def tuning_signal({x, y}) do
    x * @size + y
  end
end

defmodule Mix.Tasks.Day15 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day15-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day15.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts("This one takes a few seconds...")
    IO.puts(Day15.Part2.solve(input))
  end
end
