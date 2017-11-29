require 'sequel'

#sequel model for an environment
class Environment < Sequel::Model

    #model association
    many_to_many :monsters
end