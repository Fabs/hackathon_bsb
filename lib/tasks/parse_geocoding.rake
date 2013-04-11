desc "Import data from inep website"
task :parse_geocode => :environment do
  require 'mechanize'
  agent = Mechanize.new
  
  page = agent.post('http://www.dataescolabrasil.inep.gov.br/dataEscolaBrasil/home.seam', {
    "buscaForm" => "buscaForm",
    "codEntidadeDecorate:codEntidadeInput" => "35195145",
    "noEntidadeDecorate:noEntidadeInput" => "",
    "descEnderecoDecorate:descEnderecoInput" => "",
    "pesquisar.y" => "5",
    "pesquisar.x" => "83",
    "javax.faces.ViewState" => "j_id14",    
    "noEntidadeDecorate:noEntidadeInput" => "",
    "estadoDecorate:estadoSelect" => "org.jboss.seam.ui.NoSelectionConverter.noSelectionValue"
  })
  puts page.page
end

