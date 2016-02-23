# Growlex

An Elixir [GNTP](http://www.growlforwindows.com/gfw/help/gntp.aspx) library.

## Examples

```elixir
notifications = [
  [name: "success", enabled: true],
  [name: "failed", enabled: true]
]

Growlex.register(app_name: "My Awesome App", notifications: notifications)

Growlex.notify(name: "success", title: "WOOOOOOOO", text: "YEAAAAAAAAA!!!")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add growlex to your list of dependencies in `mix.exs`:

        def deps do
          [{:growlex, "~> 0.0.1"}]
        end

  2. Ensure growlex is started before your application:

        def application do
          [applications: [:growlex]]
        end

## TODO

- [ ] Tests
- [ ] Hex docs

## Copyright and License

Copyright (c) 2016, Atomic Fads LLC.

Plasm source code is licensed under the Apache 2 License (see LICENSE.md).
