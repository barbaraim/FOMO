module Api
  module V1
    class Events::EventsController < ApplicationController
      include AuthenticateApi
      before_action :set_event, only: %i[ show update destroy ]
      before_action :authenticate_author!, only: %i[ update destroy ]
      protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != "application/json" }
      protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == "application/json" }

      # GET /events or /events.json
      def index
        @filter_by_time = filter_index_params[:filter_by_time]
        case @filter_by_time
        when "upcoming"
          @events = Event.upcoming
        when "past"
          @events = Event.past
        when "happening_now"
          @events = Event.happening_now
        when "archived"
          @events = Event.archived
        else
          @events = Event.now_and_upcoming
        end
        render json: @events
      end

      # # GET /events/1 or /events/1.json
      def show
        render json: @event
      end

      # # GET /events/new
      # def new
      #   @event = Event.new
      # end

      # # GET /events/1/edit
      # def edit
      # end

      # # POST /events or /events.json
      def create
        @event = Event.new(event_params)
        @event.user = current_user
        if @event.save
          render json: @event
        else
          render json: @event.errors(), status: :bad_request
        end
      end

      # # PATCH/PUT /events/1 or /events/1.json
      def update
        if @event.update(event_params)
          render json: @event
        else
          render json: @event.errors(), status: :bad_request
        end
      end

      # # DELETE /events/1 or /events/1.json
      def destroy
        @event.destroy!
        render json: { message: "Event deleted successfully" }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_event
          @event = Event.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Event not found" }, status: :not_found
        end

        # Only allow a list of trusted parameters through.
        def event_params
          params.require(:event).permit(:name, :address, :start_date, :end_date, :description, :archived)
        rescue ActionController::ParameterMissing
          render json: { error: "Invalid parameters" }, status: :bad_request
        rescue ArgumentError
          render json: { error: "Invalid parameter format" }, status: :bad_request
        end

        def authenticate_author!
          render json: {
            status: 401,
            message: "Only authors can edit or delete their events."
          }, status: :unauthorized unless @event.user == current_user
        end

        def filter_index_params
          params.permit(:filter_by_time)
        end
    end
  end
end
