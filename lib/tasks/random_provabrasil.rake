desc "Generate random provabrasil"
task :random_provabrasil  => :environment do |t, args|
  School.create_random_provabrasil
end
