# == Schema Information
#
# Table name: proponents
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  name       :string           not null
#  cpf        :string           not null
#  birth_date :date             not null
#  address    :jsonb
#  phones     :jsonb
#  salary     :decimal(15, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Proponent < ApplicationRecord
  belongs_to :user

  before_validation :normalize_cpf
  validates :cpf, uniqueness: { scope: :user_id, message: 'Proponente já está presente' }
  validate -> { errors.add(:cpf, 'inválido') unless CPF.valid?(cpf) }

  store :content_attributes,
        accessors: %i[address_street address_number address_neighborhood address_city
                      address_state address_zipcode], coder: JSON

  private

  def normalize_cpf
    self.cpf = cpf.gsub(/[^\d]/, '') if cpf.present?
  end
end