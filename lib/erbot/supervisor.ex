defmodule Erbot.Supervisor do

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @bot_name Erbot.Bot
  @action_sup_name BotAction.Supervisor

  def init(:ok) do

    # API キーを取得。環境変数から取れなければconfigから取得。
    api_key = case System.get_env("ERBOT_API_KEY") do
      nil -> Application.get_env(:Erbot, :api_key)
      s -> s
    end

    # アプリケーションのSupervisorで管理する子プロセスを作成
    children = [
      supervisor(BotAction.Supervisor, [[name: @action_sup_name]]),
      worker(Erbot.Bot, [api_key, [name: @bot_name, sup_action: @action_sup_name]])
    ]

    # 戦略は `one_for_one` でSlackとアクションのsupervisorを起動
    supervise(children, strategy: :one_for_one)
  end
end
