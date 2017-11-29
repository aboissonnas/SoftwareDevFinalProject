require "sequel"

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
    if not DB.table_exists? :monsters_environments

        DB.create_join_table :monster_id => :monsters, :environment_id => :environments
    end
end