require 'sinatra/base'
require 'twilio-ruby'
require 'json'

class TwilioQueue < Sinatra::Base
  set :views, settings.root
  get '/enqueue' do

	content_type 'text/xml'

	response = Twilio::TwiML::Response.new do |r|
		r.Enqueue 'support-queue', 
			:waitUrl       => '/wait', 
			:waitUrlMethod => 'GET'
	end

	response.text

  end
  get '/dequeue' do

# Get your Account Sid and Auth Token from twilio.com/user/account 
	account_sid = 'sidhere'
	auth_token  = 'tokenhere'
    @client = Twilio::REST::Client.new account_sid, auth_token
 
	# Get an object from its sid. If you do not have a sid,
	# check out the list resource examples on this page
	queue = @client.account.queues.list.each do |queue|
	friendlyName = queue.friendly_name
		
	end
	
	@size = @client.account.queues.get("#queuenumberhere")
		if @size.current_size == 0
		response = Twilio::TwiML::Response.new do |r|
			r.Say "There are no calls currently in queue."
			r.Hangup
		end
		response.text
		else
			response = Twilio::TwiML::Response.new do |l|
				l.Say "You will now be connected to the next client"
				l.Dial do |d|
					d.Queue 'support-queue',
						:url => '/connect',
						:method => 'GET'
			end
		end
		response.text
	end
  end
  get '/wait' do

	content_type 'text/xml'

	response = Twilio::TwiML::Response.new do |r|

	  r.Say "You are number %s in line." % [@params['QueuePosition']]
	  r.Say "The average wait time is %s seconds." % [@params['AvgQueueTime']]

	  r.Play "http://com.twilio.music.rock.s3.amazonaws.com/nickleus_-_original_guitar_song_200907251723.mp3"

	end

	response.text

  end
  get '/connect' do
	
	content_type 'text/xml'
	
	response = Twilio::TwiML::Response.new do |r|
	
		r.Say "You will now be connected to an Agent."
		
	end
	
	response.text
	
  end
  get '/' do
	erb :index
	# content_type :json
	# {"num_calls" => @display}.to_json
  end	
  get '/num_calls.js' do
    coffee :num_calls
  end
  get '/num_calls' do
  	account_sid = 'sidhere'
	auth_token  = 'tokenhere'
    @client = Twilio::REST::Client.new account_sid, auth_token
	@size = @client.account.queues.get("gueueidhere")
    content_type :json
    { "num_calls" => @size.current_size }.to_json
  end
run! if app_file == $0
  end