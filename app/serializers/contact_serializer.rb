class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :birthdate#, :author

  belongs_to :kind do
    link(:related) { contact_kind_url(object.id) }#deixar o nome como related pois se trata de um objeto relacionado
  end

	has_many :phones do
    link(:related) { contact_phones_url(object.id) }
  end

  has_one :address do 
    link(:related) { contact_address_url(object.id) }
  end
  
  #para funcionar o link usando a url e nao o path, é preciso configurar no enviroments, neste caso o development.rb.Ex. abaixo:
  # Rails.application.routes.default_url_options = {
  #   host: 'localhost',
  #   port: 300
  # }
  # link(:self) { contact_url(object.id) }

  #é recomendado usar os links relacionados no propriop relacionamento, como feito acima no kind
  #link(:kind) { kind_url(object.kind.id) }

  #serve para mostrar um atributo virtual, mas desta forma parece iria como u atributo do objeto, forma nao recomendada.
  #usar a forma que esta no controller, utilizando meta: { atributo: "valor" }
  # def author
  #   "André"
  # end

  #fazendo da dorma abaixo, o atributo virtual é incluido em todos os retornos 
  meta do
    { author: "André Fernandes" }
  end  

  def attributes(*args)
    h = super(*args)
    #formato PT-BR, porem é recomedado usar o padrao americano, e quem consumir a api, trata o formato da data
    #h[:birthdate] = (I18n.l(object.birthdate) unless object.birthdate.blank?)
    #da forma abaixo, o ruby trata para seguir o padrao definido na ISO 8601
    h[:birthdate] = object.birthdate.to_time.iso8601 unless object.birthdate.blank?
    h
  end
end
