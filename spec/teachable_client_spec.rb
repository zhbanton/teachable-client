require "spec_helper"

RSpec.describe TeachableClient do
  it "has a version number" do
    expect(TeachableClient::VERSION).not_to be nil
  end
end
