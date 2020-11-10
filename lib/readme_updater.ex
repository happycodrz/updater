defmodule Updater.ReadmeUpdater do
  alias Updater.{Parallel, DataParser}

  def run() do
    DataParser.parse() |> Enum.map(fn {a, _, _} -> a end) |> run
  end
  @parallelruns 3
  @sleepduration 500


  def run(urls) do
    IO.puts "### READMEUPDATER OPTS: PARALLEL: #{@parallelruns} SLEEP: #{@sleepduration}"
    stats_collection =
      urls
      |> Parallel.run(@parallelruns, fn url ->
        res = Updater.Crawler.stats(url)
        :timer.sleep(@sleepduration)
        res
      end)
      |> Enum.map(fn {_url, stats} -> stats end)

    Updater.ReadmeHandler.replace_activity!(stats_collection)
    Updater.ReadmeHandler.replace_projects!(stats_collection)
    Updater.ReadmeHandler.replace_popularity!(stats_collection)
    Updater.ReadmeHandler.replace_commitcount!(stats_collection)
  end
end
