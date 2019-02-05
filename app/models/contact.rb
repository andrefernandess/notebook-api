class Contact < ApplicationRecord
	belongs_to :kind #,optional: true -> torna a obrigação de tipo opcional
	
    def author
			"André"
		end
		
		def kind_description
			self.kind.description
		end

		def i18n
			I18n.default_locale
		end
		
		def as_json(options={})
			super(
				root: true,
				methods: [:kind_description, :author, :i18n], 
				include: { kind: { only: :description }	}
					)
		end
end