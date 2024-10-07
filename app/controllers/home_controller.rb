class HomeController < ApplicationController
  def index
    @events = Event.all.order("start_date DESC").last(3)
    @event_comments = Comment.where(commentable_type: "Event").order("created_at DESC").last(3)
  end
end
