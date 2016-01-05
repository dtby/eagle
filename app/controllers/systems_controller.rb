class SystemsController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @systems = System.all
  end
end
