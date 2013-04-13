desc "Remove all School Data"
task :destroy_everything => :environment do |t, args|
  School.destroy_all
end
