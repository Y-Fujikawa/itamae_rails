require 'spec_helper'

describe package('monit') do
  it { should be_installed }
end

describe service('monit') do
  it { should be_enabled }
  it { should be_running }
end
