class ParticipantsController < ApplicationController
  before_action :set_participant, only: %i[ edit update ]
  before_action :authenticate_user!, only: %i[ new create edit update user_index ]

  def index
    @participants = Participant.all
  end

  def new
    @event = Event.find(params[:event_id])
    @participant = Participant.new
  end

  def create
    @event = Event.find(participant_params[:event_id])
    @participant = Participant.new(participant_params)
    @participant.user = current_user

    respond_to do |format|
      if @participant.save
        format.html { redirect_to event_url(@event), notice: "Participation was registered." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @event = Event.find(@participant.event_id)
  end

  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html { redirect_to event_url(@participant.event_id), notice: "Your participation was successfully updated." }
        format.json { render :show, status: :ok, location: @participant.event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_index
    @my_participations = Participant.where(user_id: current_user.id).preload(:event)
  end

  # def destroy
  #   @participant.destroy!

  #   respond_to do |format|
  #     format.html { redirect_to events_url, notice: "You participation was cancelled." }
  #     format.json { head :no_content }
  #   end
  # end

  private

    # Only allow a list of trusted parameters through.
    def participant_params
      params.require(:participant).permit(:participant_status, :notify, :event_id)
    end

    def set_participant
      @participant = Participant.find(params[:id])
    end
end
