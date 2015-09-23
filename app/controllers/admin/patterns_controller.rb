class Admin::PatternsController < Admin::BaseController

	def index

	end

  def show
    @pattern = Pattern.where(id: params[:id]).first
    @groups = @pattern.point_group
  end
end
