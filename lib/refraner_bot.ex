defmodule RefranerBot do
  @moduledoc """
  This module contains the main functions of the bot. It will request what is neeeded to the server
  """

  require Logger

  alias RefranerBot.{Api, MessageFormatter, Inline}
  alias RefranerBot.Model.Refran

  def get_refran(language \\ "ES") do
    with {:ok, %{body: [refran | _]}} <- Api.get_refran(language),
         {:ok, struct_refran} <- Refran.make(refran),
         {:ok, formatted_refran} <- MessageFormatter.format_refran(struct_refran) do
      {:ok, formatted_refran}
    else
      err ->
        error_message = "Could not get a refran"
        Logger.error("#{error_message}\n\n#{inspect(err)}")

        {:error, error_message}
    end
  end

  def get_refranes(opts) do
    with {:ok, %{body: refranes}} <- Api.get_refranes(opts),
         struct_refranes <- Enum.map(refranes, &Refran.make!/1) do
      {:ok, Inline.generate_articles(struct_refranes)}
    end
  end
end
