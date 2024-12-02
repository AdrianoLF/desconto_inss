class Api::V1::MembersController < ApplicationController
  def show
    render json: { user: current_user }
  end
end
