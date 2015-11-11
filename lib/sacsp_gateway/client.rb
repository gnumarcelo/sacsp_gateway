require 'sacsp_gateway/connection'

module SacspGateway
  class Client

    def conn
      @conn ||= Connection.new
    end

    def get_subjects
      #Busca todos os assuntos:
      resp_doc = conn.get('/')
      validate_field_presence(resp_doc, "comboAssunto")
      assuntos = resp_doc.xpath('//*[@name="comboAssunto"]/option').map do |it|
        {key: it.attr(:value), text: it.text }
      end
    end

    def send_ticket_subject subject_key
      #Solicitacao 1 - Seleciona Assunto
      resp_doc = conn.post('/default.asp', {
        txtAssu: '',
        comboAssunto: subject_key,
        acao2: 'Continuar'
      })
      validate_field_presence(resp_doc, "comboSubAssunto")
      specification = resp_doc.xpath('//*[@name="comboSubAssunto"]/option').map do |it|
        {key: it.attr(:value), text: it.text}
      end
    end

    def send_ticket_subject_specification specification_key
      #Solicitacao 2  - Seleciona Sub Assunto
      resp_doc = conn.post('/solicitacaoCadastro.asp', {
        comboSubAssunto: specification_key,
        acao: 'Continuar'
      })
      validate_field_presence(resp_doc, "txtDescricao")
      return true #TODO: deve mesmo retornar algo? true?
    end

    def send_ticket_request_data ticket_data
      #Solicitacao 3
      resp_doc = conn.post('/CadastroParametro/Logradouro.asp', ticket_data)
      validate_field_presence(resp_doc, "comboLogradouro")
      logradouros = resp_doc.xpath('//*[@name="comboLogradouro"]').map do |opt|
        {key: opt.attr(:value), text: opt.attr(:value).split(" ", 2).last }
      end
    end

    def send_ticket_request_data_confirmation ticket_data
      #Solicitacao 3.1
      resp_doc = conn.post('/CadastroParametro/Logradouro.asp', ticket_data)
      validate_field_presence(resp_doc, "txtRG")
      return true #TODO: deve mesmo retornar algo? true?
    end

    def send_citizen_id_info id_info
      resp_doc = conn.post('/CadastroParametro/Logradouro.asp', id_info)
      citizen_id = id_info[:txtRG]
      validate_content_value_presence(resp_doc, "td", citizen_id)
      return true #TODO: deve mesmo retornar algo? true?
    end

    def send_citizen_data_confirmation! citizen_data
      resp_doc = conn.post('/CadastroParametro/Solicitante.asp?Acao=ENVIAR', citizen_data)
      ticket_number = resp_doc.xpath('//*[@id="conteudo2"]/table/tr/td/font/b').text
      fail SacspGatewayException.new("Response is not the expected") if !ticket_number
      ticket_number
    end

  private
    def validate_field_presence resp_doc, attribute_name
      if resp_doc.xpath("//*[@name='#{attribute_name}']").size == 0
        fail SacspGatewayException.new("Response is not the expected")
      end
    end

    def validate_content_value_presence resp_doc, node_name, value
      if !resp_doc.at("#{node_name}:contains('#{value}')")
        fail SacspGatewayException.new("Response is not the expected")
      end
    end
  end
end
#https://github.com/brainspec/cloudmate/blob/c7004e45b10852e8ab4f44cfae8b98603301162f/lib/cloudmate/client.rb
