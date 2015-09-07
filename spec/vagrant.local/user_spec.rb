require 'spec_helper'

describe user('www') do
  it { should exist }
  it { should belong_to_group 'www' }}
  it { should have_login_shell '/bin/bash' }
end
