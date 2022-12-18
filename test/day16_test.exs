defmodule Day16Test do
  use ExUnit.Case

  @example_input """
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """

  test "solves example input for part 1" do
    assert Day16.Part1.solve(@example_input) == 1651
  end

  describe ".parse_input" do
    test "returns map of valves" do
      input = """
        Valve AA has flow rate=0; tunnels lead to valves BB
        Valve BB has flow rate=13; tunnels lead to valves CC, AA
      """

      output = %{
        "AA" => %{rate: 0, tunnels: ["BB"]},
        "BB" => %{rate: 13, tunnels: ["CC", "AA"]}
      }

      assert Day16.Part1.parse_input(input) == output
    end
  end

  describe ".distances_for_valve" do
    test "returns map of valves excluding 0 rate" do
      valves = %{
        "AA" => %{rate: 5, tunnels: ["BB"]},
        "BB" => %{rate: 10, tunnels: ["CC", "AA"]},
        "CC" => %{rate: 20, tunnels: ["BB", "DD"]},
        "DD" => %{rate: 0, tunnels: ["CC"]}
      }

      distances = %{
        "AA" => 0,
        "BB" => 1,
        "CC" => 2
      }

      assert Day16.Part1.distances_for_valve("AA", valves) == distances
    end
  end

  describe ".next_state" do
    test "returns new state at location with valve open" do
      state = %{
        location: "AA",
        pressure: 100,
        open_valves: ["AA"],
        minutes: 30,
        valves: %{
          "AA" => %{rate: 10, distances: %{"BB" => 2}},
          "BB" => %{rate: 20}
        }
      }

      new_state =
        %{
          state
          | location: "BB",
            pressure: 130,
            open_valves: ["BB", "AA"],
            minutes: 27
        }
        |> Map.put(:potential_pressure, 130 + 30 * 27)

      assert Day16.Part1.next_state(state, "BB") == new_state
    end
  end

  describe ".possible_states" do
    test "returns array of possible states" do
      state = %{
        location: "AA",
        pressure: 100,
        open_valves: ["BB"],
        minutes: 4,
        valves: %{
          "AA" => %{rate: 10, distances: %{"AA" => 0, "BB" => 1, "CC" => 2, "DD" => 3}},
          "BB" => %{rate: 20},
          "CC" => %{rate: 30},
          "DD" => %{rate: 40}
        }
      }

      possible_states = [
        Day16.Part1.next_state(state, "AA"),
        # BB is skipped because it's already open
        Day16.Part1.next_state(state, "CC")
        # DD is skipped because it's too far away
      ]

      assert Day16.Part1.possible_states(state) == possible_states
    end
  end
end
