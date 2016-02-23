defmodule Growlex.Options do
  def normalized_shared_options(options) do
    [
      app_name: options[:app_name] || Growlex.Mixfile.app_name,
      target_host: options[:target_host] || "localhost",
      target_port: options[:target_port] || 23053,
      password: options[:password] || "",
    ]
  end
end
