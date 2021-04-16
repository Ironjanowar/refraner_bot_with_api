defmodule RefranerBot.Api do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://localhost:4000")
  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  def get_refran(language \\ "ES") do
    get("/api/refranes?language=#{language}")
  end

  def get_refranes(opts \\ []) do
    defaults = [count: 10, search: nil, language: "ES"]

    opts =
      Keyword.merge(defaults, opts)
      |> Enum.filter(fn {_, elem} -> not is_nil(elem) end)

    get("/api/refranes", query: opts)
  end

  def get_refran_by_id(id) do
    get("/api/refranes/#{id}")
  end
end
