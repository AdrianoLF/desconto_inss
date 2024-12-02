class Api::V1::ProponentsController < ApplicationController
  before_action :proponent, only: %i[destroy update]

  MAX_RESULTS = 5
  def index
    render json: { proponents: proponents }
  end

  def create
    @proponent = user.proponents.new(permitted_params)
    @proponent.save ? render_succes : render_error
  end

  def destroy
    @proponent.destroy! and head :ok
  end

  def update
    @proponent.update(permitted_params)
    @proponent.save ? render_succes : render_error
  end

  private

  def permitted_params
    params.permit(:name, :birth_date, :salary, :cpf, :address_city, :address_neighborhood, :address_number,
                  :address_state, :address_street, :address_zipcode, phones: {})
  end

  def proponents
    @proponents ||= ProponentFinder.new(user, params).perform
                                   .page(params[:page].presence || 1)
                                   .per(MAX_RESULTS)
  end

  def proponent
    @proponent ||= user.proponents.find(params[:id])
  end

  def render_succes
    render json: { proponent: @proponent }
  end

  def render_error
    render json: { errors: @proponent.errors.full_messages }, status: :unprocessable_entity
  end
end
