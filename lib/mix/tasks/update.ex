defmodule Mix.Tasks.Update do
  use Mix.Task

  @shortdoc "Runs the Updater.run/0 function"
  def run(_) do
    Application.ensure_all_started(:updater)
    IO.puts("**************** Updating local repos...")
    Updater.Sorter.sort()
    Updater.run()
    IO.puts("**************** Updating Readme.md...")
    Updater.ReadmeUpdater.run()
  end
end
