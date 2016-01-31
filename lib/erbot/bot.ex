defmodule Erbot.Bot do
  use Slack

  def handle_connect(slack, state) do
    # 接続に成功したら呼ばれるコールバック
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_message(message = %{type: "message", text: _}, slack, state) do
    # メッセージを受け取ったら呼ばれるコールバック
    trigger = String.split(message.text, ~r{ |  })

    case String.starts_with?(message.text, "<@#{slack.me.id}>: ") do
      # botにメンション飛ばしたらrespondでプロセス作成
      true -> BotAction.Supervisor.start_action(state[:sup_action], :respond, Enum.fetch!(trigger, 1), message, slack)
      # それ以外はhearでプロセス作成
      false -> BotAction.Supervisor.start_action(state[:sup_action], :hear, hd(trigger), message, slack)
    end
    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end

end
