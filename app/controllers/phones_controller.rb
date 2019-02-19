class PhonesController < ApplicationController
	include ActionController::HttpAuthentication::Token::ControllerMethods
	before_action :authenticate
	before_action :set_contact, except: :index

	def index
		@phones = Phone.all
		render json: @phones
	end
	# GET /contacts/1/phones
	def show
		render json: @contact.phones
	end

	# POST /contacts/1/phones
	def create
		@contact.phones << Phone.new(phone_params)

		if @contact.save
			render json: @contact.phones, status: :created, location: contact_phones_url(@contact)
		else
			render json: @contact.errors, status: :unprocessable_entity
		end
	end

	# PATCH /contacts/1/phones
	def update
		phone = Phone.find(phone_params[:id])

		if phone.update(phone_params)
			render json: @contact.phones
		else
			render json: @contact.errors, status: :unprocessable_entity
		end
	end

	# DELETE /contacts/1/phones
	def destroy
		phone = Phone.find(phone_params[:id])
		phone.destroy
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_contact
		@contact = Contact.find(params[:contact_id])
	end

	def phone_params
		ActiveModelSerializers::Deserialization.jsonapi_parse(params)
	end

	def authenticate
		authenticate_or_request_with_http_token do |token, options|
			hmac_secret = 'mySecretKey'
			JWT.decode token, hmac_secret, true, {:algorithm => 'HS256'}

		end
	end
end