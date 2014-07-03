require 'pp'

class RepresentativeController < ApplicationController
  
  def by_address
    params.require(:address)
    @info = RepresentativeInfo.new params['address'], '2012'
    @pretty = PP.pp(@info, "")
  end

end

