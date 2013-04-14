desc "Remove schools without geolocation"

task :clean_schools => [:environment] do
  School.where(:location => [0, 0]).delete
  Grade.or({:media_lp.lt => 0}, {:media_mt => 0}).destroy_all
end
