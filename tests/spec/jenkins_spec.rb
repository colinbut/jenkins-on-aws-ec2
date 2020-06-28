require 'spec_helper'

describe ec2('Jenkins-Master') do
    it { should be_running }
    its(:image_id) { should eq 'ami-0089b31e09ac3fffc' }
    it { should have_security_group('Jenkins Security Group') }
end