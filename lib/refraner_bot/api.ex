defmodule RefranerBot.Api do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://localhost:4000")
  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  def get_refran(language \\ "ES") do
    get("/api/refranes?language=#{language}")
  end
end
