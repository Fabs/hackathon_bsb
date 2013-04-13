desc "Parse ts_quest_escola data"
# Example: rake create_schools[/path/to/microdados_prova_brasil_2011/Dados/TS_QUEST_ESCOLA.csv]

def getAnswer(campos, question)
  index = 6 + question
  value = campos[index]

  validAnswers = ['A', 'B', 'C', 'D']
  if validAnswers.include?(value)
    answer = value
  else
    answer = nil
  end

  return answer
end

task :parse_quest_escola, [:ts_quest_escola] => :environment do |t, args|
  codSaoPaulo = '3550308'

  IO.foreach(args.ts_quest_escola) do |linha|
    campos = linha.split(';')

    # Same names than header, but lowercase
    # Only city of São Paulo so far
    id_municipio = campos[2]
    next if id_municipio != codSaoPaulo

    # Getting school in database to be updated
    id_escola = campos[3].to_i
    school = School.find_by(:pk_cod_entidade => id_escola)

    # New information to be saved
    school.tx_resp_q037 = getAnswer(campos, 37)
    school.tx_resp_q038 = getAnswer(campos, 38)
    school.tx_resp_q056 = getAnswer(campos, 56)
    school.tx_resp_q058 = getAnswer(campos, 58)

    school.save!
  end
end
