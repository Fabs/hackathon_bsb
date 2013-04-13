#!/usr/bin/env ruby
# encoding: UTF-8

require 'geocoder'

# addresses.csv
# ID_ESCOLA;NOME;CEP;ENDEREÇO;BAIRRO
file = ARGV[0]

if ARGV.size == 1
  new = true
else
  # ID_ESCOLA of the last successful parsing
  last_id = ARGV[1]
  new = false
end

# código IBGE do município de São Paulo
#

IO.foreach(file) { |line|
  fields = line.split(';')

  id_escola = fields[0]

  if not new
    if id_escola != last_id
    else
      new = true
    end
    next
  end

  cep = fields[2]
  endereço = fields[3]
  bairro = fields[4].chomp

  if cep.size < 8
    cep = '0' * (8 - cep.size) + cep
  end
  cep = cep[0,5] + "-" + cep[5,8]

  searchString = "#{endereço}, #{bairro} - São Paulo, #{cep}"

  result = Geocoder.search(searchString)

#  require 'pp'
#  pp result

  if result.empty?
    puts "#{id_escola};#{searchString};FALHOU"
  else
    puts "#{id_escola};#{cep};#{result[0].latitude};#{result[0].longitude}"
  end
}
