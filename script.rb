require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'hangman_web'



enable :sessions

before do
  if session[:game] == nil
    session[:game] = Game.new
  end
end


get '/' do
  letter = params['letter_input']
  session[:game].enter_letter(letter)
 
  erb :index, :locals => { 
    :display_hangman => session[:game].display_hangman, 
    :display_letters => session[:game].display_letters,
    :incorrect_guesses => session[:game].incorrect_guesses,
    :incorrect_letters => session[:game].incorrect_letters,
    :win_or_lose => session[:game].win_or_lose
    }
end

post '/newGame' do
  session[:game] = nil
  redirect '/'
end

