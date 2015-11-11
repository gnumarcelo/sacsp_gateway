require 'faraday_middleware'
require 'faraday-cookie_jar'
require 'faraday'
require 'nokogiri'

module SacspGateway
  class Connection
    def initialize
      @conn = Faraday.new(:url => 'http://sac.prefeitura.sp.gov.br') do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.use :cookie_jar
        faraday.use FaradayMiddleware::FollowRedirects, limit: 3
        faraday.use Faraday::Response::RaiseError # raise exceptions on 40x, 50x responses
        faraday.adapter  Faraday.default_adapter
      end
      #@conn.headers[:user_agent] = 'SACSP::Gateway v0.0.1' # substituir versao aqui
      @conn
    end

    def post(path, data)
      response = @conn.post(path, data)
      Nokogiri::HTML(response.body)
    end

    def get(path)
      response = @conn.get(path)
      doc = Nokogiri::HTML(response.body)
    end
  end
end