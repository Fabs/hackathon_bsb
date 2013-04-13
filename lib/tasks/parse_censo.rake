desc "Import schools from micro_censo data"
# Example: rake parse_censo[/path/to/micro_censo_escolar_2012/DADOS/TS_ESCOLA.TXT]

task :parse_censo, [:file] => :environment do |t, args|
  codSaoPaulo = '3550308'

  IO.foreach(args.file) do |line|
    # Same names than PDF, but lowercase

    # Only city of São Paulo so far
    fk_cod_municipio = line[180,9].strip!
    next if fk_cod_municipio != codSaoPaulo

    school = School.new
    school.pk_cod_entidade = line[5,9].strip.to_i
    school.no_entidade = line[14,100].strip
    # Required fields
    school.location = [0, 0]
    school.gmaps = true

    school.save!
  end
end
