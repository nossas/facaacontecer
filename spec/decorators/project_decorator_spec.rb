# coding: utf-8
require 'spec_helper'

describe ProjectDecorator do
  let(:project) { Project.new.extend ProjectDecorator }
  subject { project }
  it { should be_a Project }
end
