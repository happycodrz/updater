defmodule Updater.CrawlerTest do
  import Mockery
  alias Updater.Crawler
  use ExUnit.Case
  doctest Crawler

  setup do
    case :ets.info(:fixture_cache) do
      :undefined -> :ets.new(:fixture_cache, [:named_table])
      _ -> nil
    end

    {:ok, %{}}
  end

  def fixture(file) do
    case :ets.lookup(:fixture_cache, file) do
      [{^file, content}] ->
        {:ok, content}

      [] ->
        content = "test/fixtures/#{file}" |> File.read!() |> Floki.parse()
        :ets.insert(:fixture_cache, {file, content})
        {:ok, content}
    end
  end

  test "description" do
    {:ok, body} = fixture("rails.html")
    assert Crawler.description(body) == "Ruby on Rails"
  end

  test "lastcommit - included" do
    {:ok, body} = fixture("rails-with-lastcommit.html")
    assert Crawler.lastcommit(body) == "2020-02-27T13:15:07Z"
  end

  test "lastcommit - ajax loaded" do
    {:ok, body} = fixture("rails-86e42b53662f535ee484630144e27ee684e8e8dc.html")
    assert Crawler.lastcommit(body) == "2017-11-06T10:51:18Z"
  end

  test "stars" do
    {:ok, body} = fixture("rails.html")
    assert Crawler.stars(body) == 4.68e4
  end

  test "stats" do
    {:ok, body} = fixture("rails.html")
    mock(Tesla, [get: 1], {:ok, %{body: body, status: 200}})

    expected = %{
      commitscount: 78318,
      description: "Ruby on Rails",
      lastcommit: "2020-11-05T15:25:17Z",
      repo: "https://github.com/rails/rails",
      stars: 4.68e4
    }

    assert Crawler.stats("https://github.com/rails/rails") == expected
  end
end
