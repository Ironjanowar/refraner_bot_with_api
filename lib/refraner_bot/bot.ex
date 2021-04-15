defmodule RefranerBot.Bot do
  @bot :refraner_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")
  command("refran", description: "Sends a refran")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:command, :refran, _msg}, context) do
    {_, answer_message} = RefranerBot.get_refran()
    answer(context, answer_message, parse_mode: "Markdown")
  end

  def handle({:inline_query, %{query: ""}}, context) do
    {_, articles} = RefranerBot.get_refranes(count: 10)
    answer_inline_query(context, articles)
  end

  def handle({:inline_query, %{query: search}}, context) do
    {_, articles} = RefranerBot.get_refranes(count: 10, search: search)
    answer_inline_query(context, articles)
  end

  def handle(_, _) do
    :ignored
  end
end
