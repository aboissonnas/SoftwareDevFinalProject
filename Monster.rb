require 'sequel'

#sequel model for a monster
class Monster < Sequel::Model

    #model association
    many_to_many :environments
end