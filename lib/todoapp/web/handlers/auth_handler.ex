defmodule Todoapp.Web.AuthErrorHandler do

  def unauthenticated(conn, two) do
    raise Todoapp.Web.Forbidden
  end

end
