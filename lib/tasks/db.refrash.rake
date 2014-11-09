namespace(:db) do
	task(:refresh => [:drop, :create, :migrate, :seed])
end