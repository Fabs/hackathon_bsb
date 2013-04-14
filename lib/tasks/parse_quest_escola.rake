desc "Parse ts_quest_escola data"
# Example: rake parse_quest_escola[/path/to/microdados_prova_brasil_2011/Dados/TS_QUEST_ESCOLA.csv]

def getAnswer(fields, question)
  index = 6 + question
  value = fields[index]

  validAnswers = ['A', 'B', 'C', 'D']
  if validAnswers.include?(value)
    answer = value
  else
    answer = nil
  end

  return answer
end

task :parse_quest_escola, [:file] => :environment do |t, args|
  codSaoPaulo = '3550308'

  IO.foreach(args.file) do |linha|
    fields = linha.split(';')

    # Same names than header, but lowercase
    # Only city of São Paulo so far
    id_municipio = fields[2]
    next if id_municipio != codSaoPaulo

    # Getting school in database to be updated
    id_escola = fields[3].to_i
    school = School.find_by(:pk_cod_entidade => id_escola)

    # New information to be saved
    school.tx_resp_q037 = getAnswer(fields, 37)
    school.tx_resp_q038 = getAnswer(fields, 38)
    school.tx_resp_q056 = getAnswer(fields, 56)
    school.tx_resp_q058 = getAnswer(fields, 58)

    school.save!
  end
end
