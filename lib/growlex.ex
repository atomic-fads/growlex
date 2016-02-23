defmodule Growlex do
  alias Growlex.Registration
  alias Growlex.Notification

  def register(options \\ []) do
    Registration.register(options)
  end

  def notify(options \\ []) do
    Notification.notify(options)
  end
end
