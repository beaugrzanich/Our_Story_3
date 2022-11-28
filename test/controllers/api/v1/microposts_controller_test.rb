require "controllers/api/v1/test"

class Api::V1::MicropostsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super
      @user = create(:user)
      @micropost = Micropost.new(body: "Lorem ipsum", user_id: @user.id)
      # @other_microposts = create_list(:micropost, 3, user_id: @user.id, body: "hello")
      # 🚅 super scaffolding will insert file-related logic above this line.

      @another_micropost = Micropost.new(body: "whazzzuuuu", user_id: @user.id)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(micropost_data)
      # Fetch the micropost in question and prepare to compare it's attributes.
      micropost = Micropost.find(micropost_data["id"])

      assert_equal_or_nil micropost_data['body'], micropost.body
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal micropost_data["user_id"], micropost.user_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/users/#{@user.id}/microposts", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      micropost_ids_returned = response.parsed_body.map { |micropost| micropost["id"] }
      assert_includes(micropost_ids_returned, @micropost.id)

      # But not returning other people's resources.
      assert_not_includes(micropost_ids_returned, @other_microposts[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/microposts/#{@micropost.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/microposts/#{@micropost.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      micropost_data = JSON.parse(build(:micropost, user: nil).to_api_json)
      micropost_data.except!("id", "user_id", "created_at", "updated_at")
      params[:micropost] = micropost_data

      post "/api/v1/users/#{@user.id}/microposts", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/users/#{@user.id}/microposts",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/microposts/#{@micropost.id}", params: {
        access_token: access_token,
        micropost: {
          body: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @micropost.reload
      assert_equal @micropost.body, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/microposts/#{@micropost.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Micropost.count", -1) do
        delete "/api/v1/microposts/#{@micropost.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/microposts/#{@another_micropost.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
