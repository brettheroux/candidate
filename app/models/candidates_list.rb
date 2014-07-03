require 'httparty'

class CandidatesList
  #
  # reference: http://www.followthemoney.org/services/methods.phtml
  #
  attr_accessor :raw_result, :candidates, :success, :state, :year, :district, :office
  
  def initialize(state, year, district, office, num_contributions = 25)
    @state = state
    @year = year
    @district = district
    @office = office
    @raw_result = get
    @success = @raw_result.has_key?('candidates.list.php')

    if @success
      @candidates = @raw_result['candidates.list.php']['candidate']
      @candidates.each { |candidate|
        top_contributors = CandidatesTopContributors.new candidate['imsp_candidate_id'], num_contributions
        candidate['top_contributors'] = top_contributors
      }
    else
      @candidates = @raw_result['error']
    end
  end

  def get
    url = 'http://api.followthemoney.org/candidates.list.php'
    response = HTTParty.post(url,
                  :query => { 'key' => ENV['FOLLOWTHEMONEY_KEY'],
                              'state' => @state, # 'kansas',
                              'year' => @year, # '2012',
                              'sort' => 'total_dollars',
                              'office' => @office,
                              'district' => @district }) # '049'
    response
  end

end