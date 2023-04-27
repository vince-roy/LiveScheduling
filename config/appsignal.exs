use Mix.Config

config :appsignal, :config,
  otp_app: :live_scheduling,
  name: "live_scheduling",
  env: Mix.env()
