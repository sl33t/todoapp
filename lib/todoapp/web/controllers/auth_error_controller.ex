defmodule Todoapp.Web.AuthErrorController do

  def unauthenticated(_conn, _two) do
    raise Todoapp.Web.Forbidden
  end

end
