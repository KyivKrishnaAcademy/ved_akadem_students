namespace :academic do
  desc 'Normalize telephones'
  task normalize_phones: :environment do
    Telephone.all.each do |t|
      t.phone = GlobalPhone.normalize(t.phone)

      puts "Person #{t.person_id}, telephone #{t.id}, number #{t.phone_was}" unless t.save
    end

    puts 'Done.'
  end
end
