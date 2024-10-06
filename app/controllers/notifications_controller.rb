class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: %i[ index ]

  def index
    @notifications = current_user.notifications
    # @notifications.each do |notification|
    #   notification.update(read: true)
    # end
    # @notifications.first.mark_as_unread
  end

  def mark_as_read
    notification = Noticed::Notification.find(notification_params[:id])
    notification.mark_as_read
    redirect_to notifications_url
  end

  def mark_as_unread
    notification = Noticed::Notification.find(notification_params[:id])
    notification.mark_as_unread
    redirect_to notifications_url
  end

  private
  def notification_params
    params.permit(:id)
  end
end
