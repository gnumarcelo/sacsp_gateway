# SacspGateway

Gem EXPERIMENTAL para criação de chamados no SAC da Prefeitura de São Paulo.
Criei esta gem somente para fins de estudos e ela não deve ser utilizada para aplicações em produção.

## Instalação

Adicione a linha abaixo ao seu Gemfile:

```ruby
gem 'sacsp_gateway'
```

e execute:

    $ bundle

Ou instale diretamente com o comando abaixo:

    $ gem install sacsp_gateway

## Utilização

Para criar um chamado no SAC da prefeitura de São Paulo utilizando esta gem, siga os passos abaixo nas mesma ordem (eu preferi manter os nomes como step_x uma vez que fica mais fácil de lembrar a ordem que devem ser chamados:

```ruby
#0 - Buscar a lista de assuntos que podem ser utilizados na criação de um ticket (ex.: Lixo/Limpeza, Buracos, etc.)
subjects = SacspGateway.get_subjects #Você pode manter o resultado deste método em cache
```

##IMPORTANTE: Os métodos abaixo devem ser chamados em ordem.

Iniciando o processo de criação do chamado:

```ruby
#1 - Envie o assunto do chamado, que foi selecionado com base no método que busca os assuntos.
subject_key = subjects.last[:key] #ex.: "001Buraco"
specifications = SacspGateway.step_1(subject_key)

#2 - Envie a especificação do assunto com base na lista retornada pelo pelo step_1.
specification_key = specifications.last[:key] #ex.: "200101STapa-buraco"
response = SacspGateway.step_2(specification_key)

#3 - Envia os dados do chamado, descrição rua, etc.
#    O campo Logradouro, deve que ser especificado conforme no site.
#    Ex:NÃO escreva Av. Brig. Faria Lima, escreva APENAS, Faria Lima, OU entre com o CEP sem hífen. Ex: 01452000.
ticket_data = {
  txtLogradouro: 'pouso alegre',
  txtNumero: 01,
  txtReferencia: 'na esquina c av nazare',
  txtDescricao: 'A via possui um buraco bem na esquina com a av nazare.'
}
street_occurrences = SacspGateway.step_3(ticket_data)

#3.1 - Confirma dados do endereço do chamado (com base na resposta do step_3.
#      Se o nome da rua digitada existir em mais de uma localidade, o sistema exije que se selecione
#      a qual dos endereços que a rua pertence (ex.: Rua Vergueiro existe em Santo Amaro, Liberdade e Vila Mariana).
#      Eu sei que é estranho mas infelizmente o sistema da prefeitura funciona assim (pra não dizer que é uma merda).
street_selected = street_occurrences.last[:key] # Ex.: '165590R   POUSO ALEGRE - VILA MONUMENTO'
ticket_data = {
  comboLogradouro: street_selected,
  txtNumero: 01,
  txtReferencia: 'na esquina c av nazare',
  txtDescricao: 'A via possui um buraco bem na esquina com a av nazare.'
}
response = SacspGateway.step_3_1(ticket_data)


#4 - Especifica os dados (RG, UF) de quem está abrindo o chamado (você?)
id_info = {
  txtRG: 112223334,
  comboRGUF: 'SP'
}
response = SacspGateway.step_4(id_info)


#5 - Finaliza o envio do chamado, passando os dados complementares do usuário do chamado
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

puts "Chamado criado com sucesso!!! --> #{ticket_number}"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gnumarcelo/sacsp_gateway.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

