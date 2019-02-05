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

		def birthdate_br
			I18n.l(self.birthdate) unless self.birthdate.blank?
		end
		
		def as_json(options={})
			super(
				root: true,
				methods: [:kind_description, :author, :i18n, :birthdate_br], 
				include: { kind: { only: :description }	}
					)
		end

		def to_br
			{
				name: self.name,
				email: self.email,
				birthdate: (I18n.l(self.birthdate) unless self.birthdate.blank?)
			}
		end
end