defmodule Growlex.Icon do
  alias Growlex.Crypto

  def icon(icon_path) do
    binary = binary(icon_path)
    id = md5(binary)
    size = size(binary)
    [size: size, data: binary, id: id]
  end

  defp md5(binary) do
    Crypto.md5(binary)
  end

  defp binary(icon_path) do
    {:ok, binary} = File.read(icon_path)
    binary
  end

  defp size(binary) do
    String.length(binary)
  end
end
