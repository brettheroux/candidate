find_location = () ->
  navigator.geolocation.getCurrentPosition(geolocation_success_callback, geolocation_failure_callback)

geolocation_success_callback = (position) ->
	url = '/address/reverse_geocode' 
	data = 
		longitude: position.coords.longitude, 
		latitude: position.coords.latitude
		
	jqxhr = $.getJSON url,  data, (result) -> 
		console.log('printing result') 
		console.log(result) 
		rep_url =  '/representative/by_address?'
		rep_data = 'address=' + encodeURIComponent(result.formatted_address)
		
		location.assign(location.origin + rep_url + rep_data)

###
		rep_jqxhr = $.getJSON rep_url, rep_data, (rep_result) ->
			console.log('represenative info')
			console.log(rep_result)

		rep_jqxhr.done = (rep_result) ->
			console.log(rep_result)

		rep_jqxhr.always = () ->
		# do nothing

		rep_jqxhr.fail = () -> # do nothing

	jqxhr.done = () ->
	# do nothing

	jqxhr.always = () ->
		window.ran_geocode = true

	jqxhr.fail = () ->
	# no purpose for this right now
###

geolocation_failure_callback = (error) ->
	console.log(error)
	
$ ->
	if (location.pathname == '/address/index')
		find_location()
	
