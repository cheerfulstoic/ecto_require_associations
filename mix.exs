defmodule RequireAssociations.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_require_associations,
      description: "Tool for validating that Ecto associations have been set",
      version: "0.2.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      preferred_cli_env: [
        "test.watch": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "ecto_require_associations",
      # These are the default files included in the package
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cheerfulstoic/require_associations_test"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto, ">= 2.0.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
