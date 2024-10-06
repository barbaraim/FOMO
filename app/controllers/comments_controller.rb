class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show ] # edit update destroy
  before_action :authenticate_user!, only: %i[ new create show] #  edit update destroy
  before_action :only_comments_for_first_level, only: %i[ new create ]
  before_action :only_comments_for_first_level_show, only: %i[ show ]
  before_action :only_comments_for_other_events, only: %i[ new create ]

  def new
    @comment = Comment.new
    @comment.commentable_id = route_comment_params["commentable_id"]
    @comment.commentable_type = route_comment_params["commentable_type"]
    @title = ""
    if @comment.commentable_type == "Event"
      commented_event = Event.find(@comment.commentable_id)
      @title = "for the event #{commented_event.name} by #{commented_event.user.name} #{commented_event.user.last_name}"
    elsif @comment.commentable_type == "Comment"
      commented_comment = Comment.find(@comment.commentable_id)
      @title = "for the comment #{commented_comment.review} by #{commented_comment.user.name} #{commented_comment.user.last_name}"
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @comment.commentable, notice: "Comment was successfully created."
    else
      redirect_to @comment.commentable, alert: "Comment was not created."
    end
  end

  def show
  end

  private # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

  def comment_params
    params.require(:comment).permit(:review, :rating, :commentable_id, :commentable_type)
  end

  def route_comment_params
    params.permit(:commentable_id, :commentable_type)
  end

  def only_comments_for_first_level
    return if Comments::CheckLevel.call(route_comment_params["commentable_id"], route_comment_params["commentable_type"], :new)
    flash[:alert] = "Only top level comments are allowed to be shown."
    redirect_to events_url
  end

  def only_comments_for_other_events
    check = Comments::CheckEventComments.call(route_comment_params["commentable_id"], route_comment_params["commentable_type"], current_user)
    return unless check
    flash[:alert] = check
    redirect_to event_url(route_comment_params["commentable_id"])
  end

  def only_comments_for_first_level_show
    set_comment
    return if Comments::CheckLevel.call(@comment.commentable_id, @comment.commentable_type, :show)
    flash[:alert] = "Only top level comments are allowed to be shown."
    redirect_to events_url
  end
end
