class ProponentFinder
  attr_reader :current_user, :params

  def initialize(current_user, params)
    @current_user = current_user
    @params = params
  end

  def perform
    set_proponents
    filter_by_cpf
    filter_by_name
    @proponents
  end

  private

  def filter_by_cpf
    cpf = params[:cpf]&.strip
    return if cpf.blank?

    @proponents = @proponents.where('cpf ILIKE :search', search: "%#{cpf}%")
  end

  def filter_by_name
    name = params[:name]&.strip
    return if name.blank?

    @proponents = @proponents.where('name ILIKE :search', search: "%#{name}%")
  end

  def set_proponents
    @proponents = Proponent.where(user_id: current_user.id)
  end
end
