require "sacsp_gateway/version"
require "sacsp_gateway/exception"
require "sacsp_gateway/client"

module SacspGateway
  extend SingleForwardable

  def_delegators :client, :get_subjects, :send_ticket_subject,
    :send_ticket_subject_specification, :send_ticket_request_data,
    :send_ticket_request_data_confirmation, :send_citizen_id_info,
    :send_citizen_data_confirmation!

  def self.client
    @client ||= Client.new
  end

end