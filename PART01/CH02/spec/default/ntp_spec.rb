require 'spec_helper'

describe package('ntp') do
  it { should be_installed }
end

describe service('ntpd') do
  it { should be_enabled   }
  it { should be_running   }  
end

describe command('ntpq -p') do
  it { should return_exit_status 0 }
  it { should return_stdout /\.nict\./ }
end
