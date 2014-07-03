require 'httparty'
require 'JSON'

class AddressController < ApplicationController
  def index
  end

  def geocode
  end

  def get_address()
    
  end
  
  def index()
  end
  
  def reverse_geocode()
    params.require(:latitude)
    params.require(:longitude)
    
    latlng = params['latitude'] + ',' + params['longitude']
    url = 'https://maps.googleapis.com/maps/api/geocode/json'
    post_result = HTTParty.post(url, :body => {}, :query => { 'sensor' => 'false',
                                'key' => 'AIzaSyDvlprSbMPlw2om66kb7rMtRIJxw5A4ph4',
                                            'latlng' => latlng })
    render :json => post_result['results'][0]
  end

  def reverse_geocode_II()
    latlng = params['latitude'] + ',' + params['longitude']
    url = 'https://maps.googleapis.com/maps/api/geocode/json'
    post_result = HTTParty.post(url,
                  :query => { 'key' => 'AIzaSyDvlprSbMPlw2om66kb7rMtRIJxw5A4ph4',
                              'latlng' => latlng,
                              'sensor' => false })

    formatted_address = post_result['results'][0]['formatted_address']
    representative_info = RepresentativeInfo.new

    info = representative_info.post(formatted_address)
    Rails.logger.debug JSON.pretty_generate info
    state_rep = representative_info.whoIsMyStateRepresentative(formatted_address)
    state_senator = representative_info.whoIsMyStateSenator(formatted_address)
    state_rep_office = representative_info.myStateRepresentativeOffice(formatted_address)
    state_senator_office = representative_info.myStateSenatorOffice(formatted_address)
    render :json => { :formatted_address => formatted_address, :state_rep => state_rep, :state_senator => state_senator, :state_rep_office => state_rep_office, :state_senator_office => state_senator_office }
  end

  def edit_current
  end

  def states_titlecase
  end

  def states_name_abbr
    # @states_name_and_abbreviation = StateCode.all.to_a.collect { |s| [ s.name, s.abbreviation ] }
  end

end

