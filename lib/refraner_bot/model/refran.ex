defmodule RefranerBot.Model.Refran do
  use Construct do
    field(:id, :integer)
    field(:refran, :string)
    field(:significado, :string, default: nil)
    field(:ideas_clave, :string, default: nil)
    field(:tipo, :string, default: nil)
    field(:marcador_de_uso, :string, default: nil)
    field(:comentario_marcador_de_uso, :string, default: nil)
    field(:observaciones, :string, default: nil)
    field(:observaciones_lexicas, :string, default: nil)
    field(:idioma, :string, default: nil)
    field(:idioma_codigo, :string, default: nil)
    field(:traduccion_literal, :string, default: nil)
  end

  require Logger
end
