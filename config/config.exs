use Mix.Config

if File.exists?("config/#{Mix.env()}.exs") do
  import_config "#{Mix.env()}.exs"
end

config :husky,
  pre_commit: "mix format --check-formatted && mix credo && mix hex.outdated"
