defmodule RefranerBot.Bot do
  @bot :refraner_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  require Logger

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
    case RefranerBot.get_refran() do
      {:ok, %{answer_message: answer_message, buttons: buttons}} ->
        answer(context, answer_message, parse_mode: "Markdown", reply_markup: buttons)

      {:error, error_message} ->
        answer(context, error_message, parse_mode: "Markdown")
    end
  end

  def handle({:inline_query, %{query: ""}}, context) do
    {_, articles} = RefranerBot.get_refranes(count: 10)
    answer_inline_query(context, articles)
  end

  def handle({:inline_query, %{query: search}}, context) do
    {_, articles} = RefranerBot.get_refranes(count: 10, search: search)
    answer_inline_query(context, articles)
  end

  def handle({:callback_query, %{data: "action:info:show:" <> id}}, context) do
    case RefranerBot.get_refran_by_id(id, buttons: :hide) do
      {:ok, %{edit_message: edit_message, buttons: buttons}} ->
        edit(context, :inline, edit_message, parse_mode: "Markdown", reply_markup: buttons)

      {:error, error} ->
        Logger.error("Error editing message for refran #{id}: #{error}")
    end
  end

  def handle({:callback_query, %{data: "action:info:hide:" <> id}}, context) do
    case RefranerBot.get_refran_by_id(id, buttons: :show) do
      {:ok, %{edit_message: edit_message, buttons: buttons}} ->
        edit(context, :inline, edit_message, parse_mode: "Markdown", reply_markup: buttons)

      {:error, error} ->
        Logger.error("Error editing message for refran #{id}: #{error}")
    end
  end

  def handle(_, _) do
    :ignored
  end
end
