class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :user_surveys
  has_many :surveys, through: :user_surveys
  has_many :surveys, :foreign_key => 'creator_id'

  # Signup/Signin Validaitons
  attr_reader :entered_password

  validates :name, :length => { :minimum => 3, :message => "must be at least 3 characters, fool!" }
  validates :entered_password, :length => { :minimum => 6 }
  validates :email, :uniqueness => true, :format => /.+@.+\..+/

  def surveys_taken
    user_surveys.map{|surveys_taken|Survey.find(surveys_taken.survey_id)}
  end

  # Login methods

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(pass)
    @entered_password = pass
    @password = Password.create(pass)
    self.password_hash = @password
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return user if user && (user.password == password)
    nil # either invalid email or wrong password
  end

end


# #----------- SESSIONS -----------

# get '/sessions/new' do
#   # render sign-in page
#   @email = nil
#   erb :sign_in
# end

# post '/sessions' do
#   # sign-in
#   @email = params[:email]
#   user = User.authenticate(@email, params[:password])
#   if user
#     # successfully authenticated; set up session and redirect
#     session[:user_id] = user.id
#     redirect '/'
#   else
#     # an error occurred, re-render the sign-in form, displaying an error
#     @error = "Invalid email or password."
#     erb :sign_in
#   end
# end

# delete '/sessions/:id' do
#   # sign-out -- invoked via AJAX
#   return 401 unless params[:id].to_i == session[:user_id].to_i
#   session.clear
#   200
# end


# #----------- USERS -----------

# get '/users/new' do
#   # render sign-up page
#   @user = User.new
#   erb :sign_up
# end

# post '/users' do
#   # sign-up
#   @user = User.new params[:user]
#   if @user.save
#     # successfully created new account; set up the session and redirect
#     session[:user_id] = @user.id
#     redirect '/'
#   else
#     # an error occurred, re-render the sign-up form, displaying errors
#     erb :sign_up
#   end
# end