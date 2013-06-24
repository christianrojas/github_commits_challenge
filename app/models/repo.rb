class Repo < ActiveRecord::Base
	attr_accessible :account, :repo, :chain_obj_notation
end
