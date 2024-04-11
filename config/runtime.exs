import Config

http_port =
  if config_env() == :test,
    do: System.get_env("PORT", "5455"),
    else: System.get_env("PORT", "5454")

config(:todo, http_port: String.to_integer(http_port))
