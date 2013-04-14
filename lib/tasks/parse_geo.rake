desc "Parse latitude/longitude of schools"
# Example: rake parse_geo[/path/to/geo.csv]

task :parse_geo, [:file] => :environment do |t, args|

  IO.foreach(args.file) do |linha|
    fields = linha.split(';')

    # Getting school in database to be updated
    id_escola = fields[0].to_i
    school = School.find_by(:pk_cod_entidade => id_escola)

    school.cep = fields[1]

    latitude = fields[2].to_f
    longitude = fields[3].to_f
    school.location = [latitude, longitude]

    school.save!
  end
end
