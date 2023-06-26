defmodule LiveSchedulingWeb.PagesLive.HomeTest do
  use LiveSchedulingWeb.ConnCase

  import Phoenix.LiveViewTest
  import Swoosh.TestAssertions

  describe "Subscribe to Marketing" do
    test "Creates a subscription requests", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live
             |> form("#subscribe",
               user: %{"email" => Faker.Internet.email()}
             )
             |> render_submit() =~ "Success!"

      assert_email_sent(html_body: ~r/Confirm Your Subscription/)
    end
  end
end
