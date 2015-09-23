class Admin::PatternsController < Admin::BaseController

	def index
    
	end

  def show
    @pattern = Pattern.where(id: params[:id]).first
  end
end
