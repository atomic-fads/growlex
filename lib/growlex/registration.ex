defmodule Growlex.Registration do
  import Growlex.Headers
  import Growlex.Options

  alias Growlex.Icon
  alias Growlex.Network

  def register([]) do
    {:undefined, :notifications}
  end

  def register(options) do
    check_options(options, options)
    |> do_register
  end

  def do_register({:ok, options}) do
    options
    |> normalized_options
    |> message
    |> Network.send_and_receive
  end
  def do_register(result), do: result

  def check_options(options, [{name, value} | rest]) do
    case check_option(name, value) do
      :ok -> check_options(options, rest)
      result -> result
    end
  end
  def check_options(options, []) do
    {:ok, options}
  end

  def check_option(:notifications, notifications) do
    case length(notifications) do
      0 -> {:invalid, :notifications, notifications}
      _ -> :ok
    end
  end
  def check_option(_, _), do: :ok

  def message(options) do
    notifications = options[:notifications]
    app_name = options[:app_name]

    common_headers(app_name: app_name)
    <> notifications_count_header(notifications)
    <> "\r\n"
    <> notification_headers(notifications)
    <> binary_headers(notifications)
    <> "\r\n"
  end

  def common_headers(app_name: app_name) do
    start_header
    <> application_name_header(app_name)
    <> origin_headers
  end
  def common_headers(app_name: app_name, app_icon_path: nil) do
    start_header
    <> application_name_header(app_name)
    <> origin_headers
  end
  def common_headers(app_name: app_name, app_icon_path: app_icon_path) do
    start_header
    <> application_name_header(app_name)
    <> application_icon_header(app_icon_path)
    <> origin_headers
  end

  def start_header do
    "#{start_header("REGISTER")}\r\n"
  end

  def notifications_count_header(notifications) do
    "Notifications-Count: #{length(notifications)}\r\n"
  end

  def notification_name_header(name) do
    "Notification-Name: #{name}\r\n"
  end

  def notification_enabled_header(enabled) do
    "Notification-Enabled: #{if enabled, do: "True", else: "False"}\r\n"
  end

  def notification_icon_header(nil), do: ""
  def notification_icon_header(icon_path) do
    "Notification-Icon: x-growl-resource://#{Icon.icon(icon_path)[:id]}\r\n"
  end

  def notification_headers(notifications) do
    Enum.reduce notifications, "", fn(notification, result) ->
      result
      <> notification_name_header(notification[:name])
      <> notification_enabled_header(notification[:enabled])
      <> notification_icon_header(notification[:icon_path])
      <> "\r\n"
    end
  end

  def binary_headers(notifications) do
    Enum.reduce notifications, "", fn(notification, result) ->
      result
      <> binary_header(notification[:icon_path])
    end
  end

  def binary_header(nil), do: ""
  def binary_header(icon_path) do
    icon = Icon.icon(icon_path)

    "Identifier: #{icon[:id]}\r\n"
    <> "Length: #{icon[:size]}\r\n"
    <> "\r\n"
    <> icon[:data]
    <> "\r\n"
    <> "\r\n"
  end

  def normalized_options do
    normalized_options([])
  end
  def normalized_options(options) do
    register_options = [
      notifications: options[:notifications] || [
        [name: "notify", enabled: true],
        [name: "failed", enabled: true],
        [name: "pending", enabled: true],
        [name: "success", enabled: true],
      ]
    ]

    register_options
    ++ normalized_shared_options(options)
  end
end
