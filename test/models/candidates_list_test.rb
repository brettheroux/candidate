require 'test_helper'
require 'json'

class CandidatesListTest < ActiveSupport::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  test "with proper arguments candidates are retrieved" do
    result = CandidatesList.new('kansas', '2012', '049', 'HOUSE', 25)
    assert_not_nil result.candidates
  end

  test "with proper arguments the success flag is set" do
    result = CandidatesList.new('kansas', '2012', '049', 'HOUSE', 25)
    assert result.success
  end

  test "with improper arguments the success flag is not set" do
    result = CandidatesList.new('kansas', '2052', '049', 'HOUSE', 25)
    assert !result.success
  end
  
end