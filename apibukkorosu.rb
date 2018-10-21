#! ruby -Ku
# -*- coding: utf-8 -*-
require 'json'

items = open("./item.json") do |io|
	JSON.load(io)
end

recipes = open("./recipe_item.json") do |io|
	JSON.load(io)
end

reports = open("./buy20180330.json") do |io|
	JSON.load(io)
end

tana = open("./sale_items_list.json") do |io|
	JSON.load(io)
end

tanasu = {}

tana.each do |naka|
	if naka['area_id'] == 13 then
		if !tanasu.has_key?(naka['item_id']) then
			tanasu[naka['item_id']] = 1
		else
			tanasu[naka['item_id']] = tanasu[naka['item_id']] + 1
		end
	end
end




repofvil = reports['area']['13']['system']['item']

avetana = {'1' => {'unit' => 0.0, 'money' => 0.0}}

repofvil.each do |key, rep|
	avetana[key] = {'unit' => 0.0, 'money' => 0.0}
	if tanasu[key.to_i].instance_of?(NilClass)
		tanasu[key.to_i] = 1
	end
	avetana[key]['money'] = rep['money'].to_f / tanasu[key.to_i].to_f
	avetana[key]['unit'] = rep['unit'].to_f / tanasu[key.to_i].to_f
end


File.open("トパ村最強伝説.csv", "w") do |text|
text.puts 'name,genre,money,unit,tana,price'
	avetana.each do |key, aves|
		if key.to_i < 2000000 then
			text.puts "%s,%s,%s,%s,%s,%s" % [items[key]['name'], items[key]['category'], aves['money'].to_s, aves['unit'].to_s, tanasu[key.to_i], repofvil[key]['price']]
		else
			text.puts "%s,%s,%s,%s,%s,%s" % [recipes[key]['name'], recipes[key]['category'], aves['money'].to_s, aves['unit'].to_s, tanasu[key.to_i], repofvil[key]['price']]
		end
	end
end









#以下デバッグ用のinspection

=begin
File.open("repvinsp.txt", "w") do |text|
text.puts(avetana.inspect)
end

=begin

File.open("inspection.txt", "w") do |text|
text.puts(items.inspect)
end

File.open("repinsp.txt", "w") do |text|
text.puts(repofvil.inspect)
end

File.open("tanainsp.txt", "w") do |text|
text.puts(tanasu.inspect)
end
=end