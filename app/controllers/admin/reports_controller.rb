class Admin::ReportsController < Admin::BaseController
  before_action :set_rooms, except: [:destroy]
  # load_and_authorize_resource
  authorize_resource :class => false
  
  def index
  end

  def create
    p params
    Point.new.update_report_show(params[:device_id], params[:report_points])
    respond_to do |format|
      format.js
    end
  end

  private
  def set_rooms
    if current_admin.grade == 'room'
      @rooms = current_admin.rooms.pluck(:name, :id)
    else
      @rooms = Room.all.pluck(:name, :id)
    end
  end
end
