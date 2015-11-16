require 'spec_helper'

describe SacspGateway do
  it 'has a version number' do
    expect(SacspGateway::VERSION).not_to be nil
  end

  it 'returns a list of all subjects' do
    VCR.use_cassette("subjects") do
      expect(SacspGateway.get_subjects).not_to be_empty
    end
  end

  it 'executes the step 1 - send the selected subject' do
    VCR.use_cassette("step1") do
      subject_key = "001Buraco"
      response = SacspGateway.step_1(subject_key)
      expect(response).not_to be_empty
    end
  end

  it 'executes the step 2 - send the selected a specification' do
    VCR.use_cassette("step2") do
      specification_key = "200101STapa-buraco"
      response = SacspGateway.step_2(specification_key)
      expect(response).not_to be_nil
    end
  end

  it 'executes the step 3 - send the ticket request data' do
    VCR.use_cassette("step3") do
      ticket_data = {
        txtLogradouro: 'pouso alegre',
        txtNumero: 01,
        txtReferencia: 'na esquina c av nazare',
        txtDescricao: 'A via possui um buraco bem na esquina com a av nazare. Obs.: Este chamado substitui o anterior (13412632)',
        acao: 'Continuar'
      }
      response = SacspGateway.step_3(ticket_data)
      expect(response).not_to be_empty
    end
  end

  it "executes the step 3.1 - confirms the ticket address" do
    VCR.use_cassette("step3_1") do
      logradouro_selected = '165590R   POUSO ALEGRE - VILA MONUMENTO'
      ticket_data = {
        comboLogradouro: logradouro_selected,
        txtNumero: 01,
        txtReferencia: 'na esquina c av nazare',
        txtDescricao: 'A via possui um buraco bem na esquina com a av nazare. Obs.: Este chamado substitui o anterior (13412632)',
        acao: 'Continuar'
      }
      response = SacspGateway.step_3_1(ticket_data)
      expect(response).not_to be_nil
    end
  end


  it 'executes the step 4 - send the citizen id info' do
    VCR.use_cassette("step4") do
      id_info = {
        txtRG: 112223334,
        comboRGUF: 'SP',
        acao: 'Continuar'
      }
      response = SacspGateway.step_4(id_info)
      expect(response).not_to be_nil
    end
  end

  it 'executes the step 5 (FINAL) - send the citizen data confirmation' do
    #Solicitacao 5 - FINAL
    VCR.use_cassette("step5") do

      citizen_data = {
        comboRGUF: 'SP',
        txtNome: 'Marcelo Cidadao',
        txtLogradouro: 'Rua Joao Inacio',
        txtNumero: 8424,
        txtComplemento: '123, bl4',
        txtCep: '01536001',
        txtCidade: 'Sao Paulo',
        comboUF: 'SP',
        txtTelefone: '911111111',
        txtFax: '',
        txtCPF: '',
        txtEmail: 'meuemail@gmail.com',
        comboOcupacao: '002'
      }
      ticket_number = SacspGateway.step_5!(citizen_data)
      puts "\n\n\nTicket Number: #{ticket_number}\n\n\n"
      expect(ticket_number).not_to be_nil
    end
  end
end