class Admin::PatternsController < Admin::BaseController
  before_action :set_pattern, only: [:show, :update]

	def index

	end

  def show
    @groups = @pattern.point_group
    @exclude_points = @pattern.getting_exclude_points
  end

  def update
    @exclude_points = Pattern.exclude_points_by_params(params[:points])
    @pattern.setting_point(@exclude_points)
    flash[:notice] = '设置成功'
    redirect_to admin_pattern_path(@pattern)
  end

  private 

  def set_pattern
    @pattern = Pattern.where(id: params[:id]).first
  end
end
