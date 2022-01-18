defmodule Updater.Crawler do
  alias Updater.Github

  def stats(repo) do
    cond do
      String.contains?(repo, "github.com") -> github_stats(repo)
      true -> generic_default_stats(repo)
    end
  end

  def github_stats(repo) do
    IO.puts("REQ: #{repo}")

    with {:ok, response} <- Github.get(repo) do
      body =
        cond do
          response.status == 404 ->
            IO.puts("REPO not found! #{repo}")
            raise "FUCK"
            ""

          response.status == 301 ->
            IO.puts("**** MOVED #{repo}")
            raise ""

          response.status == 429 ->
            IO.puts("*** RATELIMIT HIT for #{repo}! ***")
            raise ""

          is_binary(response.body) ->
            response.body |> Floki.parse()

          true ->
            IO.inspect(response)
            response.body
        end

      %{
        repo: repo,
        description: description(body),
        lastcommit: lastcommit(body),
        commitscount: commitscount(body),
        stars: stars(body)
      }
    else
      _ ->
        IO.puts("NOT FOUND #{repo}!")
        exit(1)
    end
  end

  def generic_default_stats(repo) do
    %{
      repo: repo,
      description: "---",
      lastcommit: "---",
      commitscount: 0,
      stars: 0
    }
  end

  def description(body) do
    body
    |> Floki.find("head title")
    |> Floki.text()
    |> String.split(": ", parts: 2)
    |> Enum.at(1)
  end

  def lastcommit(body) do
    if lastcommit_included?(body) do
      extract_included_lastcommit(body)
    else
      get_lastcommit_ajax(body)
    end
  end

  defp lastcommit_included?(body) do
    Floki.find(body, "relative-time") != []
  end

  defp extract_included_lastcommit(body) do
    body
    |> Floki.find("relative-time")
    |> Floki.attribute("datetime")
    |> Enum.at(0)
  end

  def get_lastcommit_ajax(body) do
    path =
      body
      |> Floki.find(".Box-header .js-details-container.Details")
      |> Floki.find("include-fragment")
      |> Floki.attribute("src")
      |> Enum.at(0)

    # this feels dirty...
    url = "https://github.com/" <> path

    IO.puts("AJX: #{url}")
    {:ok, doc} = Github.get(url)
    lastcommit(doc.body)
  end

  def commitscount(body) do
    body
    # quite fragile...
    |> Floki.find(".js-details-container strong")
    |> Floki.text()
    |> cleannumber_from_text
  end

  def stars(body) do
    body
    |> Floki.find("#repo-stars-counter-star")
    |> Floki.attribute("title")
    |> Enum.at(0)
    |> cleannumber_from_text()
  end

  defp cleannumber_from_text(text) do
    text
    |> String.replace(",", "")
    |> String.trim()
    |> cleantoint
  end

  defp cleantoint(""), do: 0

  defp cleantoint(v) when is_binary(v) do
    cond do
      String.contains?(v, "k") ->
        res = String.replace(v, "k", "") |> string_to_num()
        res * 1000

      true ->
        string_to_num(v)
    end
  end

  defp string_to_num(str) do
    cond do
      String.contains?(str, ".") -> String.to_float(str)
      true -> String.to_integer(str)
    end
  end
end
