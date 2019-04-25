class EventsController < ApplicationController
  before_action :logged_in, only: [:new]

  def new
    @event = Event.new
    @users = User.where.not(id: @current_user.id)
  end

  def create
    @users = User.where.not(id: current_user.id)
    @event = Event.new(creator_id: session[:user_id], title: event_params[:title],
                       info: event_params[:info], location: event_params[:location],
                       date: event_params[:date])
    @event.valid? # create @event errors before test attendance_params
    if attendance_params != ['0'] && @event.save
      attendance_params[0..-2].each do |e| # create attendances
        Attendance.create(event_id: @event.id, user_id: e.to_i)
      end
      flash[:info] = "Event created!"
      redirect_to user_path(current_user)
    else
      @event.errors.messages[:attendees] = ["can't be none"] if attendance_params == ['0']
      render 'new'
    end
  end

  private

    def event_params
      params.require(:event).permit(:title, :info, :location, :date)
    end

    def attendance_params
      params.require(:attendees)
    end

    def logged_in
      if logged_in? == false
        flash[:danger] = "Please log in."
        redirect_to(login_path)
      end
    end
end
