defmodule TypedStructLegacyReflection.MixProject do
  use Mix.Project

  @version "1.0.0"
  @repo_url "https://github.com/ejpcmac/typed_struct_legacy_reflection"

  def project do
    [
      app: :typed_struct_legacy_reflection,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Tools
      dialyzer: dialyzer(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: cli_env(),

      # Docs
      docs: [
        main: "TypedStructLegacyReflection",
        source_url: @repo_url,
        source_ref: "v#{@version}"
      ],

      # Package
      package: package(),
      description: """
      A TypedStruct plugin re-enabling the legacy reflection functions from
      TypedStruct 0.1.x.
      """
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Development dependencies
      {:ex_check, "~> 0.11.0", only: :dev, runtime: false},
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0-rc", only: :dev, runtime: false},
      {:excoveralls, ">= 0.0.0", only: :test, runtime: false},
      {:mix_test_watch, ">= 0.0.0", only: :test, runtime: false},
      {:ex_unit_notifier, ">= 0.0.0", only: :test, runtime: false},

      # Project dependencies
      {:typed_struct, "~> 0.2.0"},

      # Documentation dependencies
      {:ex_doc, "~> 0.19", only: :docs, runtime: false}
    ]
  end

  # Dialyzer configuration
  defp dialyzer do
    [
      # Use a custom PLT directory for continuous integration caching.
      plt_core_path: System.get_env("PLT_DIR"),
      plt_file: plt_file(),
      plt_add_deps: :app_tree,
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions
      ],
      ignore_warnings: ".dialyzer_ignore"
    ]
  end

  defp plt_file do
    case System.get_env("PLT_DIR") do
      nil ->
        nil

      plt_dir ->
        {:no_warn, Path.join(plt_dir, "typed_struct_legacy_reflection.plt")}
    end
  end

  defp cli_env do
    [
      # Run mix test.watch in `:test` env.
      "test.watch": :test,

      # Always run Coveralls Mix tasks in `:test` env.
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test,

      # Use a custom env for docs.
      docs: :docs
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  # Helper to add a development revision to the version. Do NOT make a call to
  # Git this way in a production release!!
  def dev do
    with {rev, 0} <-
           System.cmd("git", ["rev-parse", "--short", "HEAD"],
             stderr_to_stdout: true
           ) do
      "-dev+" <> String.trim(rev)
    else
      _ -> "-dev"
    end
  end
end
