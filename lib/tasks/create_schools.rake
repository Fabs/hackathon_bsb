desc "Create schools with micro_censo data"
# Example: rake create_schools[/path/to/micro_censo_escolar_2012/DADOS/TS_ESCOLA.txt]

task :create_schools, [:ts_escola] => :environment do |t, args|
  codSaoPaulo = '3550308'

  IO.foreach(args.ts_escola) do |linha|
    # Same names than PDF, but lowercase

    # Only city of São Paulo so far
    fk_cod_municipio = linha[180,9].strip!
    next if fk_cod_municipio != codSaoPaulo

    # Selecting data to save
    pk_cod_entidade = linha[5,9].strip.to_i
    no_entidade = linha[14,100].strip

    school = School.new
    school.pk_cod_entidade = pk_cod_entidade
    school.no_entidade = no_entidade
    
    # Required fields
    school.location = [0, 0]
    school.gmaps = true

    school.save!
  end

  puts "#{School.count} schools imported."
end
