defmodule GithubApp.PageController do
  use GithubApp.Web, :controller
  import Joken

  def index(conn, _params) do
    
  end

  def indexyz(conn, _params) do
    private_key = System.get_env("PRIVATE_APP_KEY")
    # IO.inspect private_key
    key = JOSE.JWK.from_pem(private_key)
    my_token = %{iss: 2666, iat: DateTime.utc_now |> DateTime.to_unix, exp: (DateTime.utc_now |> DateTime.to_unix) + 100}
    |> token
    |> sign(rs256(key))
    |> get_compact


    # 29418

    headers = ["Authorization": "Bearer #{my_token}", "Accept": "application/vnd.github.machine-man-preview+json"]

    # https://api.github.com
    #
    # case HTTPoison.get("https://api.github.com/app/installations", headers, []) do
    #   {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    #     IO.inspect body
    #   {:ok, %HTTPoison.Response{status_code: 404}} ->
    #     IO.puts "Not found :("
    #   {:error, %HTTPoison.Error{reason: reason}} ->
    #     IO.inspect reason
    # end

    # GET installation token

    {:ok, res} = HTTPoison.post("https://api.github.com/installations/29418/access_tokens", [], headers)
    {:ok, data} = Poison.Parser.parse(res.body)


    token = data["token"]

    # create something in the installation
    headersInstallation = ["Authorization": "token #{token}", "Accept": "application/vnd.github.machine-man-preview+json"]
    {:ok, resInstallation} = HTTPoison.get("https://api.github.com/installation/repositories", headersInstallation, [])
    {:ok, data} = Poison.Parser.parse(resInstallation.body)
    # IO.inspect data["repositories"]

    # 92847353 repo id github_app
    # post comment
    {:ok, comment} = Poison.encode(%{body: "this is a test comment"})
    {:ok, res} = HTTPoison.post("https://api.github.com/repos/SimonLab/github_app/issues/1/comments", comment, headersInstallation)
    IO.inspect res
    render conn, "index.html"
  end

  def webhook(conn, _params) do
    IO.puts "new event received"
    render conn, "webhook.html"
  end
end
