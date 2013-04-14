desc "Remove schools without geolocation"

task :clean_schools => [:environment, :parse_geo] do
  School.where(:location => [0, 0]).delete
end
