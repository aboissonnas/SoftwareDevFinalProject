require "sequel"
require "sinatra"
require 'sinatra/json'
require 'sqlite3'

def read_monster_file(filepath)
    
    #if the file exists and is a text file
    if File.exist?(filepath) and File.extname(filepath) == ".txt"
            
        #read in each line
        File.open(filepath).each do |line|
            
            #split the line into an array of data
            monster_data = line.split(",")
            
            monster = Monster[:name => monster_data.at(0)]

            #if the monster doesn't already exist
            if monster.nil?
                #populate a monster model with the data
                monster = Monster.create(:name => monster_data.at(0),
                                         :description => monster_data.at(1),
                                         :hit_points => monster_data.at(2).to_i,
                                         :ac => monster_data.at(3).to_i,
                                         :fortitude => monster_data.at(4).to_i,
                                         :reflex => monster_data.at(5).to_i,
                                         :will => monster_data.at(6).to_i,
                                         :strength => monster_data.at(7).to_i,
                                         :dexterity => monster_data.at(8).to_i,
                                         :constitution => monster_data.at(9).to_i,
                                         :intelligence => monster_data.at(10).to_i,
                                         :wisdom => monster_data.at(11).to_i,
                                         :charisma => monster_data.at(12).to_i,
                                         :xp => monster_data.at(13).to_i)

                for i in 14...(monster_data.length - 1) do

                    environ = Environment[:name => monster_data.at(i)]
           
                    #if the environment doesn't already exist
                    if environ.nil?
                        #create the environment
                        environ = Environment.create(:name => monster_data.at(i))
                    end
                            
                    #link the monster and environment
                    environ.add_monster(monster)
                end

            #if the monster already exists    
            else

                puts "Error: monster already exists in database"
            end
        end
            
        #if the file doesn't exist or isn't a text file
        else
            
        puts "Error: invalid monster file"
    end
end

#set up the database
configure do

    #connect to the sqlite database
    DB = Sequel.connect("sqlite://Monsters.db")

    #create the monsters table
    DB.create_table? :monsters do

        primary_key :id
        String :name
        String :description
        int :hit_points
        int :ac
        int :fortitude
        int :reflex
        int :will
        int :strength
        int :dexterity
        int :constitution
        int :intelligence
        int :wisdom
        int :charisma
        int :xp
    end

    #connect the monsters model
    require_relative "Monster"

    #create the environments table
    DB.create_table? :environments do

        primary_key :id
        String :name
        String :description
    end

    #connect the environments model
    require_relative "Environment"

    #create the join table for the many-to-many relationship between monsters and environments
    if not DB.table_exists? :environments_monsters

        DB.create_join_table :monster_id => :monsters, :environment_id => :environments
    end

    #populate the database
    read_monster_file("Monster.txt")
end

get '/' do
    @environs = Environment.all
    erb :home
end

post '/' do
    #grab the monsters associated with the requested environment
    envimonsters = Environment[:id => params[:environment]].monsters #monsters is an array of Monsters
    
    eligible = Array.new()
        
    #grab all monsters with appropriate xp
    envimonsters.each do |m|
    
        if m.xp <= params[:maxXP]
                
            eligible << m
        end
    end
    
    #puts "testing this dataset"
    monsters = eligible.map do |m|
       monst_info = {:mid => m.first.id, :name => m.first.name, :xp => m.first.xp, :desc => m.first.description,
    :ref => m.first.reflex, :fort => m.first.fortitude, :will => m.first.will, :str => m.first.strength,
    :dex => m.first.dexterity, :con => m.first.constitution, :intel => m.first.intelligence, :wis => m.first.wisdom,
    :cha => m.first.charisma, :hp => m.first.hit_points, :ac => m.first.ac}
    end
    return json monsters
end