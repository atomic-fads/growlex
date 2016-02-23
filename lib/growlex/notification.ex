defmodule Growlex.Notification do
  import Growlex.Headers
  import Growlex.Options

  alias Growlex.Icon
  alias Growlex.Network

  def notify([]) do
    {:undefined, :name}
  end

  def notify(options) do
    check_options(options, options)
    |> do_notify
  end

  def do_notify({:ok, options}) do
    options
    |> normalized_options
    |> message
    |> Network.send_and_receive
  end
  def do_notify(result), do: result

  def check_options(options, [{name, value} | rest]) do
    case check_option(name, value) do
      :ok -> check_options(options, rest)
      result -> result
    end
  end
  def check_options(options, []) do
    {:ok, options}
  end

  def check_option(:name, name) do
    if !name || (String.strip(name) == "") do
      {:invalid, :name, name}
    else
      :ok
    end
  end

  def check_option(:title, title) do
    if !title || (String.strip(title) == "") do
      {:invalid, :title, title}
    else
      :ok
    end
  end
  def check_option(_, _), do: :ok

  def message(options) do
    name = options[:name]
    title = options[:title]
    text = options[:text]
    icon_path = options[:icon_path]
    sticky = options[:sticky]
    app_name = options[:app_name]

    common_headers(app_name: app_name)
    <> notification_name_header(name)
    <> notification_title_header(title)
    <> notification_text_header(text)
    <> notification_sticky_header(sticky)
    <> notification_icon_header(icon_path)
    <> "\r\n"
    <> binary_header(icon_path)
    <> "\r\n"
  end

  def normalized_options do
    normalized_options([])
  end
  def normalized_options(options) do
    notify_options = [
      name: options[:name],
      title: options[:title],
      text: options[:text],
      sticky: options[:sticky],
      icon_path: options[:icon_path],
    ]

    notify_options
    ++ normalized_shared_options(options)
  end

  def common_headers(app_name: app_name) do
    start_header
    <> application_name_header(app_name)
    <> origin_headers
  end

  def start_header do
    "#{start_header("NOTIFY")}\r\n"
  end

  def notification_name_header(name) do
    "Notification-Name: #{name}\r\n"
  end

  def notification_title_header(title) do
    "Notification-Title: #{title}\r\n"
  end

  def notification_text_header(nil), do: ""
  def notification_text_header(text) do
    "Notification-Text: #{text}\r\n"
  end

  def notification_sticky_header(nil), do: ""
  def notification_sticky_header(sticky) do
    "Notification-Sticky: #{sticky}\r\n"
  end

  def notification_icon_header(nil), do: ""
  def notification_icon_header(icon_path) do
    "Notification-Icon: x-growl-resource://#{Icon.icon(icon_path)[:id]}\r\n"
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
    <> "\r\n"
  end
end
