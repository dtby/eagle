class Admin::AreasController < Admin::BaseController
  before_action :set_area, only: [:edit, :show, :update, :destroy]
  authorize_resource :class => false
  respond_to :html, :js

  def new
    @area = Area.new
    respond_with @area
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      flash[:notice] = "创建成功"
      respond_with @areas
    else
      flash[:error] = "创建失败"
      render :new
    end
  end

  def index
    @areas = Area.all
  end

  def edit
    respond_with @area
  end

  def update
    if @area.update(area_params)
      flash[:notice] = "更新成功"
    else
      flash[:notice] = "更新失败"
    end
  end

  def destroy
    @area.destroy
    redirect_to  admin_areas_path
  end

  def show

  end

  private 

  def area_params
    params.require(:area).permit(:name, :link, :monitor_link)
  end

  def set_area
    @area = Area.where(id: params[:id]).first
  end
end
