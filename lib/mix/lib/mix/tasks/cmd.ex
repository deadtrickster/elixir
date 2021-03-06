defmodule Mix.Tasks.Cmd do
  use Mix.Task

  @shortdoc "Executes the given command"
  @recursive true

  @moduledoc """
  Executes the given command.

  Useful in umbrella applications to execute a command
  on each child app:

      mix cmd echo pwd

  You can limit which apps the cmd runs in by passing the app names
  before the cmd using --only:

      mix cmd --only app1 --only app2 echo pwd

  Aborts when a command exits with a non-zero status.
  """

  @spec run(OptionParser.argv) :: :ok
  def run(args) do
    {args, apps} = parse_apps(args, [])
    if apps == [] or Mix.Project.config[:app] in apps do
      case Mix.shell.cmd(Enum.join(args, " ")) do
        0 -> :ok
        s -> exit(s)
      end
    end
  end

  defp parse_apps(args, apps) do
    case args do
      ["--only", app | tail] ->
        parse_apps(tail, [String.to_atom(app) | apps])
      args -> {args, apps}
    end
  end
end
