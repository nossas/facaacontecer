# coding: utf-8

module UserDecorator

  def first_name
    name.scan(/\w+/).first.capitalize!
  end
end

