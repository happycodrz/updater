defmodule Mix.Tasks.Readme do
  use Mix.Task

  @shortdoc "Runs the ReadmeUpdater.run/0 function"
  def run(_) do
    Application.ensure_all_started(:updater)
    IO.puts("**************** Updating Readme.md...")
    Updater.ReadmeUpdater.run()
  end
end
