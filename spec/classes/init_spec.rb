require 'spec_helper'
describe 'fmw_wls' , :type => :class do

  context 'with defaults for all parameters' do
    it { should contain_class('fmw_wls') }
  end
end
