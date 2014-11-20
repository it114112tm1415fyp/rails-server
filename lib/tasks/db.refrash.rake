namespace(:db) do
	task(:refresh => [:drop, :create, :migrate, :seed])
	namespace(:refresh) do
		task(:all) do
			tasks = [Rake::Task['db:refresh']]
			t = 0
			while tasks[t]
				tasks += tasks[t].prerequisite_tasks
				tasks.uniq!
				t += 1
			end
			%w(test development production).each do |environment|
				ENV['RAILS_ENV'] = environment
				tasks.each { |x| x.reenable }
				Rake::Task['db:refresh'].invoke
			end
		end
	end
end
