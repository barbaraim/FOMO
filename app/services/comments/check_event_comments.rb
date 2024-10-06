class Comments::CheckEventComments < ApplicationService
  def initialize(commentable_id, commentable_type, user)
    @commentable_id = commentable_id
    @commentable_type = commentable_type
    @user = user
  end

  def call
    if @commentable_type == "Event"
      commented_event = Event.find(@commentable_id)
      return "You cannot review your own event." if @user == commented_event.user
      if @user&.participants&.where(event_id: commented_event.id, participant_status: :attending).present?
        if @user&.comments&.where(commentable_id: commented_event.id, commentable_type: "Event").present?
          return "You have already reviewed this event."
        else
          false
        end
      else
        return "You must have attended the event to leave a review."
      end
    end
    false
  end
end
