defmodule Growlex.Network do
  def send_and_receive(message) do
    {:ok, socket} = :gen_tcp.connect('localhost', 23053, [active: false])
    :ok = :gen_tcp.send(socket, message)
    {:ok, response} = :gen_tcp.recv(socket, 0)

    response_string = List.to_string(response)
    receive_result(response_string)
  end

  def receive_result(response) do
    regex = ~r/GNTP\/1.0\s+-(\S+)/
    matches = Regex.scan(regex, response)
    match = List.last(List.first(matches))
    case match do
      "OK" -> :ok
      _ -> :error
    end
  end

  def hostname do
    {:ok, hostname} = :inet.gethostname
    hostname
  end
end
