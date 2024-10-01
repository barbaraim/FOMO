require "test_helper"

module Api
  module V1
    class Events::EventsControllerTest < ActionDispatch::IntegrationTest
      include Devise::Test::IntegrationHelpers

      setup do
        @event = events(:one)
        @user = users(:one)
        @other_user = users(:two)
        # binding.pry
        # login = post user_api_user_session_url, params: { "user" => { "email" => @user.email, "password" => @user.encrypted_password } }, as: :json
        @headers = { "Authorization" => "Bearer #{generate_jwt(@user)}" }
        @current_user = @user
      end

      test "should get index" do
        get api_events_url, headers: @headers, as: :json
        assert_response :success
      end

      test "should show event" do
        get api_event_url(@event), headers: @headers, as: :json
        assert_response :success
      end

      test "should create event" do
        assert_difference("Event.count") do
          post api_events_url, params: { event: { name: "New Event", address: "123 Street", start_date: "2023-12-01", end_date: "2023-12-02", description: "Event description", archived: false } }, headers: @headers, as: :json
        end
        assert_response :success
      end

      test "should not create event with invalid params" do
        post api_events_url, params: { event: { name: "" } }, headers: @headers, as: :json
        assert_response :bad_request
      end

      test "should update event" do
        patch api_event_url(@event), params: { event: { name: "Updated Event" } }, headers: @headers, as: :json
        assert_response :success
      end

      test "should not update event with invalid params" do
        patch api_event_url(@event), params: { event: { start_date: "invalid-date" } }, headers: @headers, as: :json
        assert_response :bad_request
      end

      test "should destroy event" do
        assert_difference("Event.count", -1) do
          delete api_event_url(@event), headers: @headers, as: :json
        end
        assert_response :success
      end

      test "should not update event if not author" do
        patch api_event_url(@event), params: { event: { name: "Updated Event" } }, headers: { "Authorization" => "Bearer abc123" }, as: :json
        assert_response :unauthorized
      end

      test "should not destroy event if not author" do
        delete api_event_url(@event), headers: { "Authorization" => "Bearer abc123" }, as: :json
        assert_response :unauthorized
      end

      test "should return not found for invalid event id" do
        get api_event_url(id: "invalid"), headers: @headers, as: :json
        assert_response :not_found
      end

      private

      def generate_jwt(user)
        JWT.encode({ sub: user.id }, Rails.application.credentials.devise_jwt_secret_key!)
      end
    end
  end
end
