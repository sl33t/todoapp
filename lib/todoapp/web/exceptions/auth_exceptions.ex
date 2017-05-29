defmodule Todoapp.Web.Forbidden do
  defexception [message: "You do not have access to this resource.", plug_status: 405]
end
