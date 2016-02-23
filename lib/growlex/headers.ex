defmodule Growlex.Headers do
  alias Growlex.Icon
  alias Growlex.Network

  def origin_headers do
    "Origin-Machine-Name: #{Network.hostname}\r\n"
    <> "Origin-Software-Name: #{Growlex.app_name}\r\n"
    <> "Origin-Software-Version: #{Growlex.app_version}\r\n"
    <> "Origin-Platform-Name: Windows\r\n"
    <> "Origin-Platform-Version: 0.0\r\n"
  end

  def application_name_header(app_name) do
    "Application-Name: #{app_name}\r\n"
  end

  def application_icon_header(nil), do: ""
  def application_icon_header(app_icon) do
    "Application-Icon: x-growl-resource://#{Icon.icon(app_icon)[:id]}\r\n"
  end

  def start_header(type) do
    "GNTP/1.0 #{type} NONE"
  end
end
