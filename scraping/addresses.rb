require 'nokogiri'
require 'open-uri'


# URL paraguaçu
#url = "http://www.qedu.org.br/ajax/dropdown/remote/schools/125/1983"

#URL São Paulo
url = "http://www.qedu.org.br/ajax/dropdown/remote/schools/125/2329"
doc = Nokogiri::HTML(open(url))

links = []

nodes = doc.css("a")
nodes.delete(nodes.first)

nodes.each do |item|
	links.push(item[:href])
end

links.each_with_index do |item, i|
	links[i] = item + "/contexto"
end

#links = links[1078, links.size]
links.each_with_index do |link|
	url = "http://www.qedu.org.br" + link
	school_page = Nokogiri::HTML(open(url))
	page_title = school_page.at_css("title").text
	nome = /.+: (.+) - QEdu/.match(page_title)[1]

	s = school_page.children[1].children[1].children[19].to_s
	puts s
	if s != nil
		address = /<th>Endere&Atilde;&sect;o<\/th><td>(?<rua>.+)<br \/>(?<bairro>.+)<\/td>(.+)<\/td>/.match(s)
	end 	
	if address != nil
		rua = /(.+)<br \/>[a-zA-z]+: (.*)/.match(address[:rua])[1]
		bairro = /(.+)<br \/>[a-zA-z]+: (.*)/.match(address[:rua])[2]
		cep = /CEP: ([0-9]+)/.match(s)[1]
		inep = /digo INEP<\/th><td>([0-9]+)/.match(s)[1]
		puts "#{inep};#{nome};#{cep};#{rua};#{bairro}"
	end


end