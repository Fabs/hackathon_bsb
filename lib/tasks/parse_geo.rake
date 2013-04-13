desc "Parse latitude/longitude of schools"
# Example: rake parse_quest_escola[/path/to/geo.csv]

# TODO: This is duplicated code, shared with other(s) task(s)
def find_or_create_school(id)
  results = School.where(:pk_cod_entidade => id)

  if results.count > 0
    school = results.first
  else
    school = School.create!(
      pk_cod_entidade: id,
      # Required fields
      location: [0, 0],
      gmaps: true
    )
  end

  return school
end

task :parse_geo, [:file] => :environment do |t, args|

  IO.foreach(args.file) do |linha|
    fields = linha.split(';')

    # Getting school in database to be updated
    id_escola = fields[0].to_i
    school = find_or_create_school(id_escola)

    cep = fields[1]
    latitude = fields[2].to_f
    longitude = fields[3].to_f

    # New information to be saved
    school.location = [latitude, longitude]
    school.cep = cep

    school.save!
  end
end
