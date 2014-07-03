require 'httparty'

class RepresentativeInfo

  attr_accessor :state_rep_district, :state_senate_district, :raw_result, :state_representatives,
    :state_senators, :congressional_district, :representative, :senators, :state_rep_district,
    :state_senate_district, :state, :state_rep_candidates, :state_senate_candidates

  def initialize(address, year, num_contributors = 25)
    @address = address
    @raw_result = get_api_result
    sldl = @raw_result['divisions'].keys.select { |division| division.to_s =~ /\/sldl:/ }
    @state_rep_district = "%03d" % sldl.first.split(':').last
    sldu = @raw_result['divisions'].keys.select { |division| division.to_s =~ /\/sldu:/ }
    @state_senate_district = "%03d" % sldu.first.split(':').last
    congressman = @raw_result['divisions'].keys.select { |division| division.to_s =~ /\/cd:/ }
    @congressional_district = "%03d" % congressman.first.split(':').last
    @state_representatives = get_state_representatives
    @state_senators = get_state_senators
    @representative = get_congressman
    @senators = get_senators
    @state = get_state
    @state_rep_district = get_state_rep_district
    @state_senate_district = get_state_senate_district
    @state_rep_candidates = CandidatesList.new(@raw_result['normalizedInput']['state'], year, @state_rep_district, 'HOUSE', num_contributors)
    @state_senate_candidates = CandidatesList.new(@raw_result['normalizedInput']['state'], year, @state_senate_district, 'SENATE', num_contributors)
  end

  def get_api_result
    url = URI.escape 'https://www.googleapis.com/civicinfo/us_v1/representatives/lookup'
    HTTParty.post(url,
                  :query => { 'key' => ENV['GOOGLE_CIVICS_KEY']},
                  :headers => { 'Content-Type' => 'application/json' },
                  :body => { :address => @address }.to_json )
  end

  def post(address)
    url = URI.escape 'https://www.googleapis.com/civicinfo/us_v1/representatives/lookup'
    HTTParty.post(url,
         :query => { 'key' => ENV['GOOGLE_CIVICS_KEY'] },
         :headers => { 'Content-Type' => 'application/json' },
         :body => { :address => address }.to_json )
  end

  def get_congressman
    lookup_result = @raw_result
    congressman = lookup_result['divisions'].keys.select { |division| division.to_s =~ /\/cd:/ }
    office_ids = lookup_result['divisions'][congressman.first]['officeIds']

    result = []
    office_ids.each { |office_id|
      office = lookup_result['offices'][office_id]

      office['officialIds'].each { |official_id|
        official = lookup_result['officials'][official_id]
        result << official
      }
    }
    result
  end

  def get_senators
    lookup_result = @raw_result
    
    state_office_key = lookup_result['divisions'].keys.find { |key|
      division = lookup_result['divisions'][key]
      division['scope'] == 'statewide'
    }
    state_office_ids = lookup_result['divisions'][state_office_key]['officeIds']
    senate_officials = lookup_result['offices'].select { |key, office| office['name'] == 'United States Senate' }
    office_ids = senate_officials.values.first['officialIds']
    result = []
    office_ids.each { |office_id|
      official = lookup_result['officials'][office_id]
      result << official
    }
    result
  end

  def get_state_representatives
    lookupResult = @raw_result
    sldl = lookupResult['divisions'].keys.select { |division| division.to_s =~ /\/sldl:/ }
    officeIds = lookupResult['divisions'][sldl.first]['officeIds']

    result = []
    officeIds.each { |officeId|
      office = lookupResult['offices'][officeId]

      office['officialIds'].each { |officialId|
        official = lookupResult['officials'][officialId]
        result << official
      }
    }
    result
  end
  
  def get_state_rep_district
    lookupResult = @raw_result
    sldl = lookupResult['divisions'].keys.select { |division| division.to_s =~ /\/sldl:/ }
    "%03d" % sldl.first.split(":").last
  end


  def get_state_senators
    lookupResult = @raw_result
    sldu = lookupResult['divisions'].keys.select { |division| division.to_s =~ /\/sldu:/ }
    officeIds = lookupResult['divisions'][sldu.first]['officeIds']

    result = []
    officeIds.each { |officeId|
      office = lookupResult['offices'][officeId]

      office['officialIds'].each { |officialId|
        official = lookupResult['officials'][officialId]
        result << official
      }
    }
    result
  end
  
  def get_state_senate_district
    lookupResult = @raw_result
    sldu = lookupResult['divisions'].keys.select { |division| division.to_s =~ /\/sldu:/ }
    "%03d" % sldu.first.split(":").last
  end
  
  def get_state
    lookupResult = @raw_result
    lookupResult['normalizedInput']['state']
  end

end