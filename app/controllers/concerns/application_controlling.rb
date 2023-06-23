# frozen_string_literal: true

# Concern que inclui todas as funcionalidades que ficam disponíveis no ApplicationController.
# - controle de exceções (rescue_from)
# - adição de dados a logs e auditoria
#
# Mas como precisamos estender outros controllers (ActiveStorage, por ex), extraímos para
# um concern para poder reaproveitar em outras classes.
module ApplicationControlling
  extend ActiveSupport::Concern

  included do
    include PaginationControlling
    include SerializeControlling

    rescue_from ActiveRecord::RecordInvalid,        with: :record_invalid!
    rescue_from ActiveRecord::RecordNotFound,       with: :record_not_found!
    rescue_from ActiveRecord::SubclassNotFound,     with: :subclass_not_found!
    rescue_from ActionController::ParameterMissing, with: :param_missing!

    # XXX: hoje o erro exibido será do registro com o erro
    rescue_from ActiveRecord::RecordNotDestroyed,   with: :record_invalid!
  end


  # catch-all route
  def not_found
    not_found!
  end


  private

  def record_invalid!(err = nil)
    render status: :unprocessable_entity,
          json: { error: "unprocessable_entity", errors: err&.record&.errors_as_json }
  end

  def record_not_found!(err = nil, message: "resource not found")
    not_found! err, message: (err.try(:message) || message)
  end

  def not_found!(_err = nil, status: 404, error: "not_found", message: "route not found")
    render status: status,
          json: { error: error, message: message }
  end


  def param_missing!(err = nil, message: nil, param: nil)
    message ||= err&.message || "parameter(s) missing"
    param   ||= err.param

    param_invalid! err, message: message, param: param, code: :missing
  end

  def param_invalid!(err = nil, message: nil, param: nil, code: :invalid)
    message ||= err&.message || "parameter(s) invalid"
    param   ||= err&.param

    render status: :bad_request,
          json: {
            error: "bad_request",
            message: message,
            errors: {
              param => [code]
            }
          }
  end

  def subclass_not_found!
    render status: :bad_request, json: { error: "invalid", message: "invalid type" }
  end

  def sort_params
    sort = params["sort"]

    return unless sort

    # Separa os parâmetros em itens de uma array através do padrão no Regex
    #
    # Entrada:
    # sort = 'name,price:desc'
    #
    # Saída:
    # columns = ['name', 'price:desc']
    #
    columns = sort.scan(/[a-z_]+:asc|[a-z_]+:desc|[a-z_]+/)

    return unless columns.present?

    # Cada item da array salvo anteriormente vai se tornar key:value da hash
    #
    # Entrada:
    # columns = ['name', 'price:desc']
    #
    # Saída:
    # columns = {"name"=>asc, "price"=>"desc"}
    #
    Hash[
      columns.map do |column|
        sort_attr, sort_dir = column.split(":", 2)
        sort_dir ||= "asc"

        [sort_attr, sort_dir]
      end
    ]
  end
end
