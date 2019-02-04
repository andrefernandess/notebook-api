require 'swagger_helper'

describe 'Contacts API' do

		path '/contacts' do
	
			post 'Creates a contact' do
				tags 'Contact'
				consumes 'application/json', 'application/xml'
				parameter name: :contact, in: :body, schema: {
					type: :object,
					properties: {
						name: { type: :string },
						email: { type: :string },
						birthdate: { type: :datetime }
					},
					required: [ 'name', 'status' ]
				}
	
				response '201', 'contact created' do
					let(:contact) { { name: 'Alyne', email: 'alyne@email.com', birthdate: '1990-04-30' } }
					run_test!
				end
	
				response '422', 'invalid request' do
					let(:contact) { { name: 'Alyne' } }
					run_test!
				end
			end
		end
	
		path '/contacts/{id}' do
	
			get 'Retrieves a contact' do
				tags 'contacts'
				produces 'application/json', 'application/xml'
				parameter name: :id, :in => :path, :type => :string
	
				response '200', 'name found' do
					schema type: :object,
						properties: {
							id: { type: :integer, },
							name: { type: :string },
							email: { type: :string },
							birthdate: { type: :datetime }
						},
						required: [ 'id', 'name', 'email', 'birthdate' ]
	
					let(:id) { Contact.create(name: 'Alyne', email: 'alyne@email.com', birthdate: '1990-04-30').id }
					run_test!
				end
	
				response '404', 'contact not found' do
					let(:id) { 'invalid' }
					run_test!
				end
			end
		end
	end