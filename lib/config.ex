defmodule Updater.Config do
  def root do
    Path.expand(env_root())
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

  defp env_root do
    Application.get_env(:updater, :root) || raise "UPDATER_ROOT env not set!"
  end
end
