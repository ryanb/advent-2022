defmodule Day07.Part1 do
  @size_limit 100_000

  def solve(input) do
    state = %{current: [], directories: %{}}

    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(state, &parse_line/2)
    |> sum_directories()
  end

  def parse_line(line, state) do
    cond do
      String.starts_with?(line, "$ cd") -> change_directory(line, state)
      String.starts_with?(line, "$ ls") -> prepare_directory(state)
      String.starts_with?(line, "dir") -> add_dir(line, state)
      line =~ ~r/^\d/ -> add_file(line, state)
      true -> state
    end
  end

  def change_directory(line, state) do
    [_, directory] = Regex.run(~r/^\$ cd (.+)/, line)

    case directory do
      "/" -> %{state | current: []}
      ".." -> %{state | current: tl(state.current)}
      _ -> %{state | current: [directory | state.current]}
    end
  end

  def prepare_directory(state) do
    set_current_directory(state, %{dirs: [], files: []})
  end

  def set_current_directory(state, value) do
    # Reverse here since head is the current directory
    path = state.current |> Enum.reverse() |> Enum.join("/")

    %{
      state
      | directories: Map.put(state.directories, path, value)
    }
  end

  def get_current_directory(state) do
    path = state.current |> Enum.reverse() |> Enum.join("/")
    state.directories[path]
  end

  def append_to_current_directory(state, type, value) do
    directory = get_current_directory(state)
    set_current_directory(state, Map.put(directory, type, [value | directory[type]]))
  end

  def add_dir(line, state) do
    [_, dir] = Regex.run(~r/^dir (.+)/, line)
    append_to_current_directory(state, :dirs, dir)
  end

  def add_file(line, state) do
    [_, size] = Regex.run(~r/^(\d+)/, line)
    append_to_current_directory(state, :files, String.to_integer(size))
  end

  def sum_directories(state) do
    state.directories
    |> Map.keys()
    |> Enum.map(fn path -> sum_directory(state, path) end)
    |> Enum.reduce(0, &sum_size/2)
  end

  def sum_directory(state, path) do
    dir = state.directories[path]
    Enum.sum(dir.files) + sum_sub_dirs(state, path, dir.dirs)
  end

  def sum_sub_dirs(state, path, dirs) do
    Enum.map(dirs, fn dir -> sum_sub_dir(state, path, dir) end) |> Enum.sum()
  end

  def sum_sub_dir(state, path, dir) do
    sub_path =
      if path == "" do
        dir
      else
        [path, dir] |> Enum.join("/")
      end

    sum_directory(state, sub_path)
  end

  def sum_size(size, total) do
    if size <= @size_limit do
      total + size
    else
      total
    end
  end
end

defmodule Day07.Part2 do
  @size_available 40_000_000

  def solve(input) do
    state = %{current: [], directories: %{}}

    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(state, &parse_line/2)
    |> sum_directories()
  end

  def parse_line(line, state) do
    cond do
      String.starts_with?(line, "$ cd") -> change_directory(line, state)
      String.starts_with?(line, "$ ls") -> prepare_directory(state)
      String.starts_with?(line, "dir") -> add_dir(line, state)
      line =~ ~r/^\d/ -> add_file(line, state)
      true -> state
    end
  end

  def change_directory(line, state) do
    [_, directory] = Regex.run(~r/^\$ cd (.+)/, line)

    case directory do
      "/" -> %{state | current: []}
      ".." -> %{state | current: tl(state.current)}
      _ -> %{state | current: [directory | state.current]}
    end
  end

  def prepare_directory(state) do
    set_current_directory(state, %{dirs: [], files: []})
  end

  def set_current_directory(state, value) do
    # Reverse here since head is the current directory
    path = state.current |> Enum.reverse() |> Enum.join("/")

    %{
      state
      | directories: Map.put(state.directories, path, value)
    }
  end

  def get_current_directory(state) do
    path = state.current |> Enum.reverse() |> Enum.join("/")
    state.directories[path]
  end

  def append_to_current_directory(state, type, value) do
    directory = get_current_directory(state)
    set_current_directory(state, Map.put(directory, type, [value | directory[type]]))
  end

  def add_dir(line, state) do
    [_, dir] = Regex.run(~r/^dir (.+)/, line)
    append_to_current_directory(state, :dirs, dir)
  end

  def add_file(line, state) do
    [_, size] = Regex.run(~r/^(\d+)/, line)
    append_to_current_directory(state, :files, String.to_integer(size))
  end

  def sum_directories(state) do
    sizes =
      state.directories
      |> Map.keys()
      |> Enum.map(fn path -> sum_directory(state, path) end)

    over = sum_directory(state, "") - @size_available
    sizes |> Enum.filter(fn size -> size >= over end) |> Enum.sort() |> hd
  end

  def sum_directory(state, path) do
    dir = state.directories[path]
    Enum.sum(dir.files) + sum_sub_dirs(state, path, dir.dirs)
  end

  def sum_sub_dirs(state, path, dirs) do
    Enum.map(dirs, fn dir -> sum_sub_dir(state, path, dir) end) |> Enum.sum()
  end

  def sum_sub_dir(state, path, dir) do
    sub_path =
      if path == "" do
        dir
      else
        [path, dir] |> Enum.join("/")
      end

    sum_directory(state, sub_path)
  end
end

defmodule Mix.Tasks.Day07 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day07-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day07.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day07.Part2.solve(input))
  end
end
