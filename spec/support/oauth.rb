module Support
  module Integration
    def mock_oauth(provider)
      case provider
      when :facebook

        OmniAuth.config.mock_auth[:facebook] = {
          "uid" => '123123123',
          "provider" => 'facebook',
          "credentials" => {"token" => 'sometoken'},
          "extra" => {"raw_info" => {
            "id" => '123123123',
            "locale" => "en_GB",
            'last_name' => 'Last Name',
            'first_name' => 'First Name'
            }.with_indifferent_access },
          "info"  => {
            "email" => 'foo@example.com',
            "urls" => {
              "Facebook" => "http://facebook.com/example"
            }
          }.with_indifferent_access
        }.with_indifferent_access
      else
        throw 'Invalid OAuth provider'
      end

      OmniAuth.config.test_mode = true
    end
  end
end
