class Api::V1::InssCalculationsController < ApplicationController
  def disccount
    salary = params[:salary].to_f
    discount = InssDisccountCalculatorService.new.perform(salary)
    render json: { salary: salary, inss_discount: discount }, status: :ok
  end
end
