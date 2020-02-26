# Updater

A helper package to maintain Github URLs

## Installation

```elixir
def deps do
  [
    {:updater, github: "happycodrz/updater"}
  ]
end
```

## Usage

```bash

# create a wrapper Elixir project
$ mix new ex

# add updater deps
$ vim ex/mix.exs
...
  {:updater, github: "happycodrz/updater"}


# configure Makefile
$ vim Makefile

update_jsonlibs:
  export UPDATER_ROOT=$$(pwd)/jsonlibs; cd ex && mix update

# setup folder structure
$ mkdir jsonlibs

$ mkdir jsonlibs/data
$ echo "https://github.com/michalmuskala/jason [] A blazing fast JSON parser and generator in pure Elixir." > jsonlibs/data/urls.txt
$ touch jsonlibs/Readme.md

# run updater
$ make update_jsonlibs
```
