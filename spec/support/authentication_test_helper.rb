# frozen_string_literal: true

module AuthenticationTestHelper
  module Methods
    def authenticate_with_access_token!(resource: nil, scopes: :api_mobile)
      user        = resource || create(:user)
      application = create(:application, scopes: scopes)
      token       = instance_double("Doorkeeper::AccessToken", acceptable?: true, scopes: scopes, resource_owner_id: user.id)

      allow_any_instance_of(described_class).to receive(:authenticate_user!)

      allow_any_instance_of(described_class).to receive(:doorkeeper_token).and_return(token)
    end

    def reset_authentication!
      # removendo stubs, com "#and_call_original"
      %i[
        authenticate_user!
        doorkeeper_token
      ].each do |method_name|
        allow_any_instance_of(described_class).to receive(method_name).and_call_original
      end
    end
  end
end


RSpec.configure do |config|
  config.include AuthenticationTestHelper::Methods, type: :request
  config.include AuthenticationTestHelper::Methods, type: :controller
end
