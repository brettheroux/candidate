class CandidatesTopContributors

  attr_accessor :imsp_candidate_id, :top_contributors

  def initialize(imsp_candidate_id, num_contributors = 20)
    @imsp_candidate_id = imsp_candidate_id
    @num_contributors = num_contributors
    @top_contributors = get
  end

  def get()
    url = 'http://api.followthemoney.org/candidates.top_contributors.php'
    response = HTTParty.post(url,
                  :query => { 'key' => ENV['FOLLOWTHEMONEY_KEY'],
                              'imsp_candidate_id' => @imsp_candidate_id })
    if response['candidates.top_contributors.php'].nil?
      return nil
    end
    record_count = response['candidates.top_contributors.php']['record_count']
    total_dollars = response['candidates.top_contributors.php']['total_dollars']
    sum_dollars = 0
    contributor_count = 0
    result_array = Array.new
    response['candidates.top_contributors.php']['top_contributor'].each { |contributor|
      contributor_name = contributor['contributor_name']
      contributor_dollars = contributor['total_dollars']
      sum_dollars += contributor_dollars.to_i
      contributor_count += 1
      if contributor_count < @num_contributors
        result_object = Hash.new
        result_object['contributor_name'] = contributor_name
        result_object['total_dollars'] = contributor_dollars
        result_array << result_object
      end
    }
    result_array
  end

end