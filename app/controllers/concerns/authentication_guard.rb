module AuthenticationGuard
  extend ActiveSupport::Concern

  class Error < ::StandardError
    attr_reader :status, :code

    def initialize(*args, status: nil, code: nil)
      super(*args)

      @status = status unless status.nil?
      @code   = code unless code.nil?
    end

    def default_status
      500
    end

    def default_code
      "unauthorized"
    end

    def status
      @status || default_status
    end

    def code
      @code || default_code
    end
  end

  included do
    include ::AuthenticationGuard::ControllerMethods

    rescue_from ::AuthenticationGuard::Error do |e|
      render status: e.status, json: { error: e.code, message: e&.message }
    end
  end

  module ControllerMethods
    # filters
    # ---

    protected

    def authenticate_user
      doorkeeper_authorize! default_auth_scope
    end

    # helpers
    # ---

    private

    def current_user
      return current_resource_owner if doorkeeper_token

      warden.authenticate(scope: :user)
    end

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
