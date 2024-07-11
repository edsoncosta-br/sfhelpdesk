class Customer < ApplicationRecord
  validates :code, presence: true
  validates :code, numericality: { greater_than: 0 }, if: -> { code != nil}
  validates :code, uniqueness: {scope: :company_id}
  validates :name, presence: true, length: {maximum: 70}
  validates :cpfcnpj_number, presence: true, length: {maximum: 18}

  validates :address, length: {maximum: 50}
  validates :number, length: {maximum: 8}
  validates :complement, length: {maximum: 20}
  validates :district, length: {maximum: 30}
  validates :zip_code, length: {maximum: 9}
  validates :phone, length: {maximum: 15}
  validates :cellphone, length: {maximum: 15}

  validate :code_isempty
  validate :name_isempty
  validate :state_isempty
  validate :city_isempty
  validate :cpfcnpj_isempty
  validate :cpfcnpj_isvalid

  has_many :requests

  belongs_to :city
  belongs_to :company  

  attr_accessor :state
  attr_accessor :code_generated
  
  def code_f
    self.code.to_s.rjust(5, '0')
  end

  private

  def code_isempty
    if self.code.blank?
      errors.add(:_, '_code_isempty_')
    end
  end

  def cpfcnpj_isempty
    if self.cpfcnpj_number.blank?
      errors.add(:_, '_cpfcnpj_number_isempty_')
    end    
  end

  def name_isempty
    if self.name.blank?
      errors.add(:_, '_name_isempty_')
    end
  end

  def state_isempty
    if self.state.blank?
      errors.add(:_, '_state_isempty_')
    end
  end

  def city_isempty
    if self.city_id.blank?
      errors.add(:_, '_city_isempty_')
    end
  end

  def cpfcnpj_isvalid
    if self.type_person == Constants::TYPE_PERSON_JURIDICA
      if (!self.cpfcnpj_number.blank?) and  (!CNPJ.valid?(self.cpfcnpj_number))
        errors.add(:_, '_cpfcnpj_isinvalid_')
      end
    elsif self.type_person == Constants::TYPE_PERSON_FISICA
      if (!self.cpfcnpj_number.blank?) and  (!CPF.valid?(self.cpfcnpj_number))
        errors.add(:_, '_cpfcnpj_isinvalid_')
      end
    end
  end
  
end
