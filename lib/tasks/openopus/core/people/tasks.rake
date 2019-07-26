namespace :openopus do
  namespace :core do
    namespace :people do
      desc "Generate one or many random people in your database. Requires 'gem rest-client'. Only for testing!"
      task :generate_people, [:count] => :environment do |task, args|
        def generate_person
          json = ActiveSupport::HashWithIndifferentAccess.new(JSON(RestClient::Request.execute(method: :get, url: 'https://randomuser.me/api?format=json&nat=US').body))
          jp = json[:results][0]
          l = jp[:location]
          a = Address.new
          a.line1 = l[:street].titleize; a.city = l[:city].titleize; a.state = l[:state].titleize;
          a.postal = l[:postcode].to_s.upcase; a.country = "US"
          name = jp[:name]
          p = Person.create(name: "#{name[:title]} #{name[:first]} #{name[:last]}".titleize,
                            phone: jp[:phone], address: a, email: jp[:email],
                            birthdate: jp[:dob][:date], nationality: jp[:nat])
          p.picture = jp[:picture][:medium] if p.respond_to?("picture=".to_sym)
          p.photo = jp[:picture][:medium] if p.respond_to?("photo=".to_sym)
          p
        end

        count = args[:count]
        count ||= 1
        count.to_i.times do
          person = generate_person
          puts("openopus made: #{person.name} of #{person.address.oneline}")
        end
      end

      desc "Generate users from the people in your database that aren't associated with any user. Only for testing!"
      task :generate_users, [:count] => :environment do |task, args|
        def generate_user(person)
          User.create(person_id: person.id, status: "generated") if not person.user
        end

        Rake::Task["openopus:core:people:generate_people"].invoke(args[:count]) if not args[:count].blank?
        Person.all.each { |person| generate_user(person) }
      end
    end
  end
end
