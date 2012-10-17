def mock_server_and_api
  @api_mock = mock(VideoSystemApi::VideoSystemApi)
  @server_mock = mock_model(VideoServer)
  @server_mock.stub(:api).and_return(@api_mock)
  VideoServer.stub(:find).and_return(@server_mock)
end

def mocked_server
  @server_mock
end

def mocked_api
  @api_mock
end

def centisize(amount)
  return (amount.to_f * 100).round
end
  
def dollarize(amount)
  return (amount.to_f / 100).round(2)
end

# Compares the attributes of two models or hashes, ignoring attributes generated only when saving in the db
# Example: user1.should have_same_attributes_as(User.last)
RSpec::Matchers.define :have_same_attributes_as do |expected|
  match do |actual|
    ignored = ['id', 'updated_at', 'created_at']
    actual_attr = actual.attributes unless actual.instance_of?(Hash)
    expected_attr = expected.attributes unless expected.instance_of?(Hash)
    actual_attr.except(*ignored) == expected_attr.except(*ignored)
  end
end