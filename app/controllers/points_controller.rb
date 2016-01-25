class PointsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:get_value_by_name]

  def get_value_by_names
    
    names = get_value_by_names_params[:names]
    names = names.split("|")

    @values = {}
    names.each do |name|
      point = Point.find_by(name: name)
      next unless point.present?
      @values[point.name] = point.value
    end
  end

  private
    
    def get_value_by_names_params
      params.require(:point).permit(:names)
    end
end
