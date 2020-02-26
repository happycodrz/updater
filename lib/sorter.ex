defmodule Updater.Sorter do
  alias Updater.Config
  def sort() do
    sort(Config.urls_file())
  end

  def sort(file) do
    content = File.read!(file)

    updated =
      content
      |> String.split("\n")
      |> Enum.sort(&(String.downcase(&1) <= String.downcase(&2)))
      |> Enum.reject(&(String.replace(&1, " ", "") == ""))
      |> Enum.join("\n")

    File.write(file, updated)
  end
end
