require 'spec_helper'
describe 'sonarqube' do

  context 'with defaults for all parameters' do
    it { should contain_class('sonarqube') }
  end
end
