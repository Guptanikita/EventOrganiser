require 'rake'
require 'csv'

namespace :load_config do

    desc 'create users from csv file'
    task :load_users => :environment do
        file_name = './lib/tasks/input_files/users.csv'
        csv_text = File.read(file_name)
        csv = CSV.parse(csv_text)
        csv.shift
        csv.each do |row|
            user_name = row[0].strip
            email = row[1].strip
            phone = row[2].strip
            
            user = User.new(:user_name => user_name, :email => email, :phone => phone)
            if user.save
                puts "User #{user_name} created successfully."
            else
                puts "Error :: #{user.errors.full_messages} while creating #{user_name}"
            end
        end
    end

    desc 'create events from csv file'
    task :load_events => :environment do
        file_name = "./lib/tasks/input_files/events.csv"
        csv_text = File.read(file_name)
        csv = CSV.parse(csv_text)
        csv.shift
        csv.each do |row|
            title = row[0]
            from = Time.parse(row[1])
            to = Time.parse(row[2])
            description = row[3]
            users_rsvp = row[4].split(":") if row[4].present?
            all_day = row[5]
            user_map = []
            organiser_key = nil
            if users_rsvp.present?
                users_rsvp.each do |user|
                    temp = user.split("#")
                    user_name = temp[0]
                    rsvp = temp[1]
                    user = User.where(:user_name => user_name).first
                    user_map.push({"user_key" => user.user_key, "rsvp" => rsvp})
                    organiser_key = user.user_key if rsvp == "yes" && organiser_key.nil?
                end
            end
            event = Event.new(:title => title, :from => from, :to => to, :description => description,
                :all_day => all_day, :user_key => organiser_key)
            if event.save
                if user_map.present?
                    user_map.each do |user|
                        user_key = user["user_key"]
                        rsvp = user["rsvp"]
                        invitee = Invitee.new(:event_key => event.event_key, :user_key => user_key, :response => rsvp)
                        invitee.save
                    end
                end
            else
                puts("Error while creating event :: #{title}")
            end
            
        end
    end
end 