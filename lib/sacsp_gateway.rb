require "sacsp_gateway/version"
require "sacsp_gateway/exception"
require "sacsp_gateway/client"

module SacspGateway
  extend SingleForwardable

  def_delegators :client, :get_subjects, :step_1, :step_2, :step_3,
    :step_3_1, :step_4, :step_5!

  def self.client
    @client ||= Client.new
  end

end