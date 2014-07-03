#require 'test/unit'
require 'test_helper'
require 'json'

class RepresentativeInfoTest < ActiveSupport::TestCase

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

  test "run a default post" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe, KS', '2012'
    result = representative_info.raw_result
    print JSON.pretty_generate result.as_json

    assert_not_nil result

    # Rails.logger.debug JSON.pretty_generate result.as_json

    Rails.logger.debug 'keys are: ' + result.keys.join(', ')
    Rails.logger.debug 'divisions keys are: ' + result['divisions'].keys.join(', ')

    sldl = result['divisions'].keys.select { |division| division.to_s =~ /\/sldl:/ }

    assert_equal(sldl.count, 1)

    Rails.logger.debug 'state rep district is: ' + "%03d" % sldl.first.split(':').last
    Rails.logger.debug 'sldl is: ' + sldl.first
    Rails.logger.debug 'name is: ' + result['divisions'][sldl.first]['name']
    Rails.logger.debug 'officeIds are: ' + result['divisions'][sldl.first]['officeIds'].join(', ')

    officeIds = result['divisions'][sldl.first]['officeIds']

    officeIds.each { |officeId|
      office = result['offices'][officeId]
      Rails.logger.debug "office name is: " + office['name']
      Rails.logger.debug "official ids are: " + office['officialIds'].join(', ')

      office['officialIds'].each { |officialId|
        official = result['officials'][officialId]
        Rails.logger.debug "name of the official is: " + official['name']
      }
    }
    sldu = result['divisions'].keys.select { |division| division.to_s =~ /\/sldu:/ }

    assert_equal(sldu.count, 1)

    Rails.logger.debug 'state senate district is: ' + "%03d" % sldu.first.split(':').last
    Rails.logger.debug 'sldu is: ' + sldu.first
    Rails.logger.debug 'name is: ' + result['divisions'][sldu.first]['name']
    Rails.logger.debug 'officeIds are: ' + result['divisions'][sldu.first]['officeIds'].join(', ')

    officeIds = result['divisions'][sldu.first]['officeIds']

    officeIds.each { |officeId|
      office = result['offices'][officeId]
      Rails.logger.debug "office name is: " + office['name']
      Rails.logger.debug "official ids are: " + office['officialIds'].join(', ')

      office['officialIds'].each { |officialId|
        official = result['officials'][officialId]
        Rails.logger.debug "name of the official is: " + official['name']
      }
    }
  end

  test "make sure who is my state representative works" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe KS', '2012'
    assert_equal(representative_info.state_representatives.count, 1)
    assert_equal(representative_info.state_representatives.first['name'], 'Scott Schwab')
  end

  test "make sure who is my state senator works" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe KS', '2012'
    assert_equal(representative_info.state_senators.count, 1)
    assert_equal(representative_info.state_senators.first['name'], 'Robert Olson')
  end

  test "make sure who is my congressman works" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe KS', '2012'
    assert_equal(representative_info.representative.count, 1)
    assert_equal(representative_info.representative.first['name'], 'Kevin Yoder')
  end

  test "get state rep district" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe KS', '2012'
    assert_equal(representative_info.state_rep_district, '049')
  end

  test "get state senate district" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe KS', '2012'
    assert_equal(representative_info.state_senate_district, '023')
  end

  test "get congressmen" do
    representative_info = RepresentativeInfo.new '12735 S. Hagan Ct. Olathe KS', '2012'
    assert_equal(representative_info.congressional_district, '003')
  end

end
