defmodule BotAction.Action do
  use Slack

  def hear("hear?", message, slack) do
    send_message("I can hear", message.channel, slack)
  end

  def hear("バルス", message, slack) do
    send_message("へああ", message.channel, slack)
  end

  # Don't remove. This is default pattern.
  def hear(_, _, _) do
  end

  def respond("respond?", message, slack) do
    send_message("I can respond", message.channel, slack)
  end

  # Don't remove. This is default pattern.
  def respond(_, _, _) do
  end
end
