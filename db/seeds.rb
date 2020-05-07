# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



for i in (1..2000)
	Item.create(:sku => i, :name => "#{i}Name", :price => "12.00", :stock_amount => "100")
end

StoreConfiguration.create(store_name: 'validsol',email_address: 'amirad2020@gmail.com',website_url: 'http://validsol.com',currency: '$')
User.create(username:'admin@gmail.com',email:'admin@gmail.com',password:'aaaaaa')