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

$ pushd ex ; mix deps.get ; mix compile ; popd

# configure Makefile (please make sure to use TABs for indentation!)
$ vim Makefile

update_jsonlibs:
  export UPDATER_ROOT=$$(pwd)/jsonlibs; cd ex && mix update

# setup folder structure

$ mkdir -p jsonlibs/data
$ echo "https://github.com/michalmuskala/jason [] A blazing fast JSON parser and generator in pure Elixir." > jsonlibs/data/urls.txt

# create update-able Readme, example here: https://raw.githubusercontent.com/happycodrz/updater/master/test/fixtures/Readme.md
$ touch jsonlibs/Readme.md

# run updater
$ make update_jsonlibs
```
