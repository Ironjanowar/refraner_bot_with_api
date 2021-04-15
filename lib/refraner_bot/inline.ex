defmodule RefranerBot.Inline do
  alias RefranerBot.Model.Refran
  alias RefranerBot.MessageFormatter

  alias ExGram.Model.InlineQueryResultArticle
  alias ExGram.Model.InputTextMessageContent

  def generate_article(%Refran{} = refran) do
    case MessageFormatter.format_refran(refran) do
      {:ok, formatted_refran} ->
        %InlineQueryResultArticle{
          type: "article",
          id: refran.id,
          title: refran.refran,
          input_message_content: %InputTextMessageContent{
            message_text: formatted_refran,
            parse_mode: "Markdown"
          },
          description: refran.tipo || ""
        }

      _ ->
        nil
    end
  end

  def generate_article(_),
    do: nil

  def generate_articles([%Refran{} | _] = refranes),
    do: refranes |> Enum.map(&generate_article/1) |> Enum.filter(& &1)

  def generate_articles(_), do: []
end
