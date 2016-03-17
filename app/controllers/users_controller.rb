class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:show]
  def show
  end
end
