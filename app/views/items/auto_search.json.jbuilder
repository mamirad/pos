json.items do
	json.array!(@items) do |item|
		json.name item.name
		json.id item.id
	end
end