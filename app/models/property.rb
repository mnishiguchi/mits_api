require 'json'

=begin
Attributes:
  @source: {Hash} The source hash
  @community
  @floorplans
  @utility
  @address
=end

class Property < ApplicationRecord
  include ActiveModel::Serializers::JSON

  attr_reader :source,
              :community,
              :floorplans,
              :address,
              :utility,
              :photo

  def attributes=(hash)
    raise "Must be a hash" unless hash.is_a? Hash

    @source     = hash.extend Hashie::Extensions::DeepFind
    @community  = hash.deep_find(:community)
    @floorplans = hash.deep_find(:floorplans)
    @utility    = hash.deep_find(:utility)
    @address    = hash.deep_find(:address)
    @photo      = hash.deep_find(:file)
  end

  # The hash representation of the address in our format.
  # Gets called when #to_json method is invoked.
  def attributes
    instance_variables.map do |var|
      [var[1..-1], instance_variable_get(var)]
    end.to_h
  end

  def from_hash(hash)
    self.attributes = hash
  end

  def to_hash
    self.attributes
  end
end
