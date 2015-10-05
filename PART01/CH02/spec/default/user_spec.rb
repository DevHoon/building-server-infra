require 'spec_helper'

describe user('naoya') do
  it { should exist }
  it { should belong_to_group 'naoya' }
  it { should have_home_directory '/home/naoya' }
  it { should have_login_shell '/bin/bash' }
end
