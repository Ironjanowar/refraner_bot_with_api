defmodule RefranerBot.Inline do
  alias RefranerBot.Model.Refran
  alias RefranerBot.MessageFormatter

  alias ExGram.Model.InlineQueryResultArticle
  alias ExGram.Model.InputTextMessageContent

  def generate_article(%Refran{} = refran) do
    with {:ok, formatted_refran} <- MessageFormatter.format_refran(refran, :summary),
         {:ok, buttons} <- generate_buttons(refran.id, :show) do
      %InlineQueryResultArticle{
        type: "article",
        id: refran.id,
        title: refran.refran,
        input_message_content: %InputTextMessageContent{
          message_text: formatted_refran,
          parse_mode: "Markdown"
        },
        reply_markup: buttons,
        description: refran.tipo || ""
      }
    else
      _ ->
        nil
    end
  end

  def generate_article(_),
    do: nil

  def generate_articles([%Refran{} | _] = refranes),
    do: refranes |> Enum.map(&generate_article/1) |> Enum.filter(& &1)

  def generate_articles(_), do: []

  def generate_buttons(refran_id, :show) do
    buttons = [[[text: "Show info", callback_data: "action:info:show:#{refran_id}"]]]
    {:ok, ExGram.Dsl.create_inline(buttons)}
  end

  def generate_buttons(refran_id, :hide) do
    buttons = [[[text: "Hide info", callback_data: "action:info:hide:#{refran_id}"]]]
    {:ok, ExGram.Dsl.create_inline(buttons)}
  end

  def generate_buttons(refran_id, _),
    do: {:error, "Can't generate buttons for refran #{refran_id}"}
end
