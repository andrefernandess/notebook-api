namespace :dev do
  desc "Configura o ambiente de Desenvolvimento"
  task setup: :environment do

    puts "Cadastrando tipos de contato!!!"

    kinds = %w(Amigo Comercial Conhecido)

    kinds.each do |kind|
      Kind.create!(
        description: kind
      )
    end

    puts "Tipos cadastrados com sucesso!!!"

    puts "Cadastrando Contatos"
    100.times do |i|
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        birthdate: Faker::Date.between(65.years.ago, 18.years.ago),
        kind: Kind.all.sample
      )
    end
    puts "Contatos cadastrados com sucesso!!!"

  end

end
