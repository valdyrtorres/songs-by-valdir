require 'sass'
require 'sinatra'
require 'slim'
require './song'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

# O código dentro do bloco de configuração é executado apenas uma vez na inicialização
configure :development do
   DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

get('/styles.css'){ scss :styles }

get '/' do
  slim :home
end

get '/about' do
  @title = "All About This Website"
  slim :about
end

get '/contact' do
  slim :contact
end

not_found do
  slim :not_found
end

get '/fake-error' do
  status 500
  "There's nothing wrong, really :P"
end 

get '/set/:name' do
  session[:name] = params[:name]
end

get '/get/hello' do
  "Hello #{session[:name]}"
end

get '/login' do
  slim :login
end

get '/logout' do
  session.clear
  redirect to('/login')
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    slim :login
  end
end
