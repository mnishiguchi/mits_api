require "test_helper"

describe Property do
  let(:property) { Property.new }

  it "must be valid" do
    value(property).must_be :valid?
  end
end
