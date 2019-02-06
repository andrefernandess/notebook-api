class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]

  # GET /contacts
  def index
    @contacts = Contact.all

    #render json: @contacts, root: true -> mostra o tipo de objeto json no retorno, neste caso Contact
    # -> render json: @contacts.map { |contact|  contact.attributes.merge({ author: "André" })}  # desta forma faz um merge com atrbutos que nao pertencem a class, usando o .map
    # 2 forma ->render json: @contacts, methods: :author, root: true
    #abaixo,tercera forma usando o metodo as_json sobrescrito na classe Contact. Forma mais indicada
    render json: @contacts, include: [:kind, :address, :phones]
  end

  # GET /contacts/1
  def show
    # render json: @contact.attributes.merge({ author: "André" })# mesmo caso para apenas um elemento
    render json: @contact, include: [:kind, :address, :phones], meta: { author: "André" }#->forma usada sem a gem AMS, include: [:kind, :phones, :address]
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, include: [:kind, :phones, :address], status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact, include: [:kind, :phones, :address]
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      #metodo padrão, deve ser alterado qndo trabalha com AMS
      # params.require(:contact).permit(
      #   :name, :email, :birthdate, :kind_id,
      #   phones_attributes: [:id, :number, :_destroy],
      #   address_attributes: [:id, :street, :city]
      # )
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      #para definir os campos aceitos com no .pertmit, usar:ActiveModelSerializers::Deserialization.jsonapi_parse(params ,only: [:campo1, :campo2])

      #pode definir chaves para atributos com nomes diferentes, Exp:
      #ActiveModelSerializers::Deserialization.jsonapi_parse(params, { :nome => :name, :data => created_at })
    end
end
