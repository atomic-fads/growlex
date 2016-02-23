defmodule Growlex do
  alias Growlex.Registration
  alias Growlex.Notification

  def register(options \\ []) do
    Registration.register(options)
  end

  def notify(options \\ []) do
    Notification.notify(options)
  end

  def app_name do
    "growlex"
  end

  def app_version do
    "0.1.0"
  end
end
