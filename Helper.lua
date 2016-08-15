-- Credits to Rob Miracle; https://coronalabs.com/blog/2014/09/30/tutorial-how-to-shuffle-table-items
math.randomseed( os.time() )
function shuffleTable( t )
	local rand = math.random
	assert( t, "shuffleTable() expected a table, got nil" )
	local iterations = #t
	local j

	for i = iterations, 2, -1 do
		j = rand(i)
		t[i], t[j] = t[j], t[i]
	end
end
