defmodule GithubApp.PageControllerTest do
  use GithubApp.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert 2 == 3
  end
end
