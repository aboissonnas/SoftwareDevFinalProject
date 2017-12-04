require 'sinatra'
require 'sequel'
require 'sinatra/json'
require 'sqlite3'

enable :sessions

#lets make some tables friendos
configure do

    #open the database at large
    DB = Sequel.connect('sqlite://CharCreator.db')

    #Character table holds all the characters that have been created thusfar
    DB.create_table? :characters do
        primary_key :id
        String :character
        String :player
        foreign_key :racename, :races
        foreign_key :spellbook_id, :spellbooks
        foreign_key :role_id, :roles # class is a keyword. Also, multiclassing is a thing but this is SIMPLIFIED D&D. No multiclassing!!! (....yet)
        Integer :str 
        Integer :dex
        Integer :con
        Integer :intel #Not sure if calling int will mess things up so let's just call it intel
        Integer :wis
        Integer :cha 
        Integer :level
        String :bio # if player wants to give their char a tragic backstory

    end

    #Race in D&D matters. Not skin color, but literally is this character an elf, a gnome, etc.
    #Humans have no buff or penalty, but other races have adv and disadv
    #For example I think half-orcs get +2 to con and -2 to int
    DB.create_table? :races do
        primary_key :id
        String :racename #this will be the most frequently referenced
        Integer :buff1
        String :buff1where 
        Integer :buff2
        String :buff2where
        Integer :penalty
        String :penaltywhere 
        String :description #what the heckie is this race?? tell us pls
    end

    DB.create_table? :spellbooks do
        primary_key :spellbook_id
        foreign_key :id, :characters
    end
#spells are intricate so I left all the attack stuff to flavortext because it's not like
# I'm going to implement a combat system
    DB.create_table? :spells do 
        primary_key :spell_id
        String :spellname #how do I keep forgetting to put names of things in these tables???
        Integer :level
        String :flavortext
        foreign_key :role_id, :roles # alright we'll make it a fk to make things more specific
    end

    DB.create_table? :roles do 
        primary_key :role_id
        String :rolename
        String :description
        TrueClass :magical # Apparently ruby doesn't have booleans according to the internet, so.
    end

    DB.create_join_table?(spellbook_id: :spellbooks, spell_id: :spells)

    #insert default races
    #Taking loosely from 5e but they have bullshit like humans get +1 to all abilities.
    # .... if I have time I might update my race table to have fields for all stat bonuses/penalties
    # actually that's way smarter than having a second string called buff1where
    DB.transaction do

        rec = DB[:races].where(:racename => "Human")
        if 1 != rec.update(:racename => "Human")
            DB[:races].insert(:racename => "Human", :buff1 => 0, :buff1where => "Strength", :buff2 => 0, :buff2where => "Strength", :penalty => 0, :penaltywhere => "Strength", :description => "Humans range in skintone from dark brown to a pale peach. They reach adulthood in their late teens, and live less than a century. Humans tend towards no particular alignment or class. They vary in size and build, but are generally 5-6 feet tall. Regardless of height, humans are Medium sized with a walking speed of 30ft. They know Common and one other language of your choice, however they tend to sprinkle words borrowed from other languages into their Common, such as Orcish curses and Elvish musical expressions.")
        end
        rec = DB[:races].where(:racename => "Elf")
        if 1 != rec.update(:racename => "Elf")
            DB[:races].insert(:racename => "Elf", :buff1 => 2, :buff1where => "Dexterity", :buff2 => 0, :buff2where => "Strength", :penalty => 2, :penaltywhere => "Constitution", :description => "Elves are an old race, able to live to nearly 1000 years. Although they mature in their teens like humans, culturally elves do not consider themselves to be adults until around 100. Elves value freedom, variety, and self-expression, and thus tend to be Chaotic Good or Chaotic Neutral. Heightwise, they range from under 5 feet tall to over 6 feet tall, but all are Medium creatures that have a speed of 30 ft. Since they have keen senses, they possess Darkvision, which means they can see in dim light as well as they can see in bright light, and even darkness is like dim light. They cannot discern color in darkness, however. They have Advantage on Perception, and on saving throws against being Charmed. An elf cannot be put to sleep by magic, since elves do not really sleep. Instead, they go into a four hour trance where they meditate deeply. This gives the same benefits as a Human sleeping for 8 hours. Elves can speak, read, and write both in Common and Elvish.")
        end

        rec = DB[:races].where(:racename => "Half-Elf")
        if 1 != rec.update(:racename => "Half-Elf")
            DB[:races].insert(:racename => "Half-Elf", :buff1 => 2, :buff1where => "Charisma", :buff2 => 0, :buff2where => "Strength", :penalty => 0, :penaltywhere => "Strength", :description => "Half-elves are half elf, and half human. Half-elves reach maturity in their late teens, and are considered adults in their 20s. While they do not live as long as full-blooded elves, half-elves can live to be nearly 200 years old. Half-Elves tend to be chaotically aligned, but do not tend towards good or evil. Half-elves range from 5-6 feet tall, and all are Medium sized. Since they have elven ancestry, half-elves also have Darkvision and can see even in complete darkness. Half-elves, also like elves, cannot be put to sleep by magic, and have Advantage on being Charmed. They can speak, read, and write Common, Elvish, and one other language of the player's choice.")
        end

        rec = DB[:races].where(:racename => "Halfling")
        if 1 != rec.update(:racename => "Halfling")
            DB[:races].insert(:racename => "Halfling", :buff1 => 2, :buff1where => "Dexterity", :buff2 => 0, :buff2where => "Strength", :penalty => 2, :penaltywhere => "Strength", :description => "Halflings (also known as hobbits) are short, dextrous, and kind. They reach maturity at around age 20 and tend to live to the middle of their second century. They are generally 3 feet tall and weigh around 40 pounds, so they are Small creatures. Halflings tend to be community-oriented, and thus are usually Lawful Good. Halflings are slower than other races, with a speed of 25 ft. Halflings are very Lucky, so if they roll a natural 1, they can reroll it but must take the second roll. They are also Brave, and get Advantage on saving throws against being Frightened. Since they are Nimble, they can move through the space of any creature that is Medium sized. Halflings speak, read, and write Common and Halfling. Halfling is not a secret language, but they do not like to share the Halfling language with non-Halflings. ")
        end

        rec = DB[:races].where(:racename => "Half-Orc")
        if 1 != rec.update(:racename => "Half-Orc")
            DB[:races].insert(:racename => "Half-Orc", :buff1 => 2, :buff1where => "Strength", :buff2 => 1, :buff2where => "Constitution", :penalty => 2, :penaltywhere => "Charisma", :description => "Half-orcs are half Orc, half human. They are not often the result of a loving union. They mature faster than humans, reaching adulthood at about 14, and age faster overall, with half-orcs rarely living past 75. Half-orcs tend to be chaotic creatures, and when raised in Orc society tend to be Evil. While they are larger and tend to be bulkier than humans at 5 to well over 6 feet tall, half-orcs are Medium sized. They have a walking speed of 30 ft. Half-orcs can see in complete darkness. They are also Menacing, and get proficiency in the Intimadation skill. They have Relentless Endurance, and can be reduced to 1 hit point instead of 0 if they are reduced to 0 but not outright killed. Half-orcs also make Savage Attacks, so when they land a critical hit, you can roll an extra damage dice of the weapon and add it to the damage total. Half-orcs can speak, read, and write Common and Orc. Orcs do not have their own script, and instead use Dwarven letters. ")
        end

        rec = DB[:races].where(:racename => "Gnome")
        if 1 != rec.update(:racename => "Gnome")
            DB[:races].insert(:racename => "Gnome", :buff1 => 2, :buff1where => "Constitution", :buff2 => 0, :buff2where => "Strength", :penalty => 2, :penaltywhere => "Strength", :description => "Gnomes are slightly larger than Halflings. They average between 3 and 4 feet tall and weigh in at around 40 pounds, making them Small. Gnomes reach adulthood at 20, and are expected to settle down at 40. They can live between 350 and 500 years. Most gnomes are Good, with no preference towards Law or Chaos. Since gnomes are Small, they are slower than taller races and have a speed of 25 ft. Gnomes have Darkvision, and can see in complete darkness. They also have a special sort of Gnome Cunning, which gives Advantage on all Intelligence, Wisdom, and Charisma saving throws. Gnomes can speak, read, and write Common and Gnome. The Gnome language uses the Dwarven alphabet.")
        end

        rec = DB[:races].where(:racename => "Dwarf")
        if 1 != rec.update(:racename => "Dwarf")
            DB[:races].insert(:racename => "Dwarf", :buff1 => 2, :buff1where => "Constitution", :buff2 => 0, :buff2where => "Strength", :penalty => 2, :penaltywhere => "Charisma", :description => "Dwarves are like Gnomes but stockier and more into rocks.")
        end
    end

    #Default roles. Starting with just the basic four since I don't got time for real D&D.
    DB.transaction do
        rec = DB[:roles].where(:rolename => "Fighter")
        if 1 != rec.update(:rolename => "Fighter")
            DB[:roles].insert(:rolename => "Fighter", :description => "Fighters swing swords and hit things.", :magical => 0) 
        end

        rec = DB[:roles].where(:rolename => "Rogue")
        if 1 != rec.update(:rolename => "Rogue")
            DB[:roles].insert(:rolename => "Rogue", :description => "Rogues also hit things, but are sneaky and can do a lot of damage with their Sneak Attack", :magical => 0) 
        end

        rec = DB[:roles].where(:rolename => "Wizard")
        if 1 != rec.update(:rolename => "Wizard")
            DB[:roles].insert(:rolename => "Wizard", :description => "Wizards are magical and cast spells. Don't wear armor or else spells fail. They cast out of Intelligence, so make your wizard super smart.", :magical => 1) 
        end

        rec = DB[:roles].where(:rolename => "Cleric")
        if 1 != rec.update(:rolename => "Cleric")
            DB[:roles].insert(:rolename => "Cleric", :description => "Clerics use the power of their deity to heal things. They can also hit things, but mainly they heal. They cast out of Wisdom, so make your cleric super wise.", :magical => 1) 
        end
    end

    #Now that we have roles, we can slap on some default spells.
    DB.transaction do

        #I was going to grab the roles, but then I realized /I already know what id they're gonna be because autoincrementing/
        # Are magic numbers bad? Heck yes
        # But I don't have my models yet as of this transact so I'll use them
        # I'll at least assign the id to a variable so if it changes later it changes in just one spot

        wizard = 3
        cleric = 4

        rec = DB[:spells].where(:spellname => "Ray of Frost")
        if 1 != rec.update(:spellname => "Ray of Frost")
            DB[:spells].insert(:spellname => "Ray of Frost", :flavortext => "Shoot some cold at your opponent. Roll 1d4 to determine damage.", :level => 0, :role_id => wizard) 
        end

        rec = DB[:spells].where(:spellname => "Acid Splash")
        if 1 != rec.update(:spellname => "Acid Splash")
            DB[:spells].insert(:spellname => "Acid Splash", :flavortext => "Shoot some literal acid at your opponent. Roll 1d4 to determine damage.", :level => 0, :role_id => wizard) 
        end

        rec = DB[:spells].where(:spellname => "Electric Jolt")
        if 1 != rec.update(:spellname => "Electric Jolt")
            DB[:spells].insert(:spellname => "Electric Jolt", :flavortext => "Zap your opponent. Roll 1d4 to determine damage.", :level => 0, :role_id => wizard) 
        end

        rec = DB[:spells].where(:spellname => "Cure Minor Wounds")
        if 1 != rec.update(:spellname => "Cure Minor Wounds")
            DB[:spells].insert(:spellname => "Cure Minor Wounds", :flavortext => "Heal the target for 1d4.", :level => 0, :role_id => cleric)
        end

        rec = DB[:spells].where(:spellname => "Light")
        if 1 != rec.update(:spellname => "Light")
            DB[:spells].insert(:spellname => "Light", :flavortext => "Shine some light on the situation. You create a bright light that shines for 30 ft in a burst pattern", :level => 0, :role_id => cleric) 
        end

    end

end

class Character < Sequel::Model
    one_to_many :races
    one_to_one :spellbooks
    one_to_many :roles
end

class Role < Sequel::Model
    many_to_one :characters
end

class Spellbook < Sequel::Model
    one_to_one :characters
    many_to_many :spells
end

class Race < Sequel::Model
    many_to_one :characters
end
# I put a Spell on you, cause you're miiine~
class Spell < Sequel::Model
    many_to_many :spellbooks
end

get '/' do

    @allcharacters = Character.all
    erb :home
end

get '/newCharacter' do

    @races = Race.all
    @roles = Role.all
    erb :charcreate
end

post '/newCharacter' do

    if params[:rid]
        flavor = Race[:id => params[:rid]]

        return json flavor.description

    elsif params[:roid]
        flavor = Role[:role_id => params[:roid]]

        return json flavor.description
    elsif params[:role]
        spells = Spell.where(:role_id => params[:role]).map do |s|
            spell_info = {:sid => s.spell_id, :name => s.spellname, :level => s.level, :flavortext => s.flavortext}

        end

        return json spells
    elsif params[:char]
        book = Spellbook.create();

        if(params[:spell] != nil)
        params[:spells].each do |spell|
        book.add_spell(spell)
        end

        end

        char = Character.create(:character => params[:char], :player => params[:play], :bio => params[:bio], :racename => params[:race],
        :role_id => params[:therole], :str => params[:strength], :dex => params[:dex], :con => params[:con],
        :intel => params[:intel], :wis => params[:wis], :cha => params[:cha], :level => 1, :spellbook_id => book.spellbook_id)

        book.id = char.id

        thisRace = Race[:id => params[:race]]
        if(thisRace.buff1where == "Strength")
            char.str += thisRace.buff1
        elsif(thisRace.buff1where == "Dexterity")
            char.dex += thisRace.buff1
        elsif(thisRace.buff1where == "Constitution")
            char.con += thisRace.buff1
        elsif(thisRace.buff1where == "Intelligence")
            char.intel += thisRace.buff1
        elsif(thisRace.buff1where == "Wisdom")
            char.wis += thisRace.buff1
        elsif(thisRace.buff1where == "Charisma")
            char.cha += thisRace.buff1
        end

        if(thisRace.buff2where == "Strength")
            char.str += thisRace.buff2
        elsif(thisRace.buff2where == "Dexterity")
            char.dex += thisRace.buff2
        elsif(thisRace.buff2where == "Constitution")
            char.con += thisRace.buff2
        elsif(thisRace.buff2where == "Intelligence")
            char.intel += thisRace.buff2
        elsif(thisRace.buff2where == "Wisdom")
            char.wis += thisRace.buff2
        elsif(thisRace.buff2where == "Charisma")
            char.cha += thisRace.buff2
        end

        if(thisRace.penaltywhere == "Strength")
            char.str -= thisRace.penalty
        elsif(thisRace.penaltywhere == "Dexterity")
            char.dex -= thisRace.penalty
        elsif(thisRace.penaltywhere == "Constitution")
            char.con -= thisRace.penalty
        elsif(thisRace.penaltywhere == "Intelligence")
            char.intel -= thisRace.penalty
        elsif(thisRace.penaltywhere == "Wisdom")
            char.wis -= thisRace.penalty
        elsif(thisRace.penaltywhere == "Charisma")
            char.cha -= thisRace.penalty
        end



        redirect '/'

    end



end

get '/newRace' do

    erb :homebrewrace
end

get '/newSpell' do

    @roles = Role.where(:magical => 1)

    erb :homebrewspell
end


get '/newClass' do 

    erb :homebrewclass
end

post '/newSpell' do
    name = params[:sname]
    if(Spell[:spellname => name])
        return "Spell with that name already exists, try again"
    else
        Spell.create(:spellname => name, :level => params[:lv], :flavortext => params[:desc], :role_id => params[:role])
        redirect '/'
    end

end

post '/newRace' do

    name = params[:rname]
    if(Race[:racename => name])
        return "Race with that name already exists, try again"
    else
        Race.create(:racename => name, :description => params[:desc], :buff1 => params[:buff1], :buff2 => params[:buff2],
        :penalty => params[:penalty], :buff1where => params[:b1where], :buff2where => params[:b2where], :penaltywhere => params[:pwhere])
        redirect '/'
    end

end