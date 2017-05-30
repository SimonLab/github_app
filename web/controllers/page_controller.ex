defmodule GithubApp.PageController do
  use GithubApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def webhook(conn, _params) do
    IO.puts "new event received"
    render conn, "webhook.html"
  end
end
