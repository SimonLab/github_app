defmodule GithubApp.PageController do
  use GithubApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
