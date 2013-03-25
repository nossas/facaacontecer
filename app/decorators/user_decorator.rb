# coding: utf-8

module UserDecorator

  def first_name
    name.capitalize!.split(' ').first
  end
end

