defmodule Updater.Config do
  def root do
    Application.get_env(:updater, :root)
  end

  def srcfolder do
    Path.join([root(), "src"])
  end

  def urls_file do
    Path.join([root(), "data/urls.txt"])
  end

  def readme_file do
    Path.join([root(), "Readme.md"])
  end
end