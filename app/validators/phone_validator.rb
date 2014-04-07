# coding: utf-8
class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[(]{1}[0-9]{2}[)]{1} [0-9]{8,9}\z/i
      record.errors[attribute] << (options[:message] || "não é um telefone válido")
    end
  end
end

