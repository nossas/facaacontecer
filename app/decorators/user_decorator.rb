# coding: utf-8

module UserDecorator

  def first_name
    name.capitalize!.scan(/[[:word:]]+/u).first
  end
end

