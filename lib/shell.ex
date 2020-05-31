defmodule Updater.Shell do
  def run(cmd) do
    if String.contains?(cmd, "reset --hard") do
      blocking_run(cmd)
    else
      streaming_run(cmd)
    end
  end

  defp blocking_run(cmd) do
    :os.cmd(cmd |> String.to_charlist()) |> List.to_string()
  end

  defp streaming_run(cmd) do
    list = String.split(cmd)
    {bin, args} = List.pop_at(list, 0)
    System.cmd(bin, args, into: IO.stream(:stdio, :line))
  end
end
