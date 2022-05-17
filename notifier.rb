require 'net/http'
require 'uri'
require 'JSON'

#Access API key
reader = File.open('api_key.txt','r')
key = reader.readline
reader.close

#Get user from location
print "Enter home city: "
home_location = gets

#Get user to location
print "Enter destination city: "
dest_location = gets

uri = URI('https://maps.googleapis.com/maps/api/distancematrix/json?origins=' + home_location + '&destinations=' + dest_location + '&key=' + key)

res = Net::HTTP.get_response(uri)
json_response = JSON.parse(res.body)

time_sec = json_response['rows'][0]['elements'][0]['duration']['value']
time_min = json_response['rows'][0]['elements'][0]['duration']['text']

if time_sec > 600 then
    post_uri = URI('https://maker.ifttt.com/trigger/Google_Notifier/with/key/cu-0QxWSdbV5uQRZTdr8Ol')
    res = Net::HTTP.post_form(post_uri,{'value1'=>home_location, 'value2'=>dest_location, 'value3'=>time_min})
    puts "\n"+ 'Running late email sent. Step on it buddy' + "\n"
else
    p "\n" + 'You can make it to work on time. Hooray' + "\n"
end
