defmodule Solution do
  def main(args) do
    case args do
      [filename] -> read_file(filename)
      _ -> IO.puts("Usage: elixir file_reader.exs <filename>")
    end
  end

  defp read_file(filename) do
    case File.read(filename) do
      {:ok, content} -> IO.puts(process_file(content))
      {:error, reason} -> IO.puts("Error reading file: #{reason}")
    end
  end

  defp process_file(content) do
    Regex.scan(~r/don\'t\(\)|do\(\)|mul\([0-9]+,[0-9]+\)/, content)
      |> Enum.reduce({:do, []},  &filter_dont/2)
      |> elem(1)
      |> Enum.map(&process_line/1)
      |> Enum.reduce(fn val, acc -> val + acc end)
  end

  defp filter_dont([val], acc) do
    case val do
      "do()" -> put_elem(acc, 0, :do)
      "don't()" -> put_elem(acc, 0, :dont)
      num -> case acc do
        {:do, acc_val} -> 
          {:do, acc_val ++ [num]}
        a -> a
      end
    end
  end

  defp process_line(match) do
    case Regex.run(~r/[0-9]+,[0-9]+/, match) do
      [match] -> parse_numbers(String.split(match, ","))
      nil -> nil
    end
  end

  defp parse_numbers(num_strs) do
    Enum.map(num_strs, &parse_number/1)
      |> Enum.reduce(fn val, acc -> acc * val end)
  end

  defp parse_number(x) do
    {int_val, ""} = Integer.parse(x) 
    int_val
  end
end

Solution.main(System.argv())
