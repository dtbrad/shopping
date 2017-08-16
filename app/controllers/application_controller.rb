class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_domain
  helper_method :set_graph, :sort_column, :sort_direction
  before_action :require_password_change

  def about; end

  def privacy; end

  def tos; end

  def welcome; end

  def log_out_to_register
    reset_session
    redirect_to new_user_registration_path
  end

  def send_password_email
    User.find_by(email: params[:user][:email]).send_reset_password_instructions
    redirect_to new_user_session_path, flash: { notice: 'If a user with that email exists, a reset-password email has been sent to them' }
  end

  private

  def require_password_change
    if current_user && current_user.generated_from_email == true && current_user.changed_password < 1 &&
       !['devise/registrations', 'devise/sessions'].include?(params[:controller])
      redirect_to edit_user_registration_path, flash: { notice: 'Please change your password' }
    end
  end

  def ensure_domain
    return if request.env['HTTP_HOST'] == ENV['WEB_URL'] || Rails.env.development?
    redirect_to "https://#{ENV['WEB_URL']}", status: 301
  end

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password, :changed_password]
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  def initialize_omniauth_state
    session['omniauth.state'] = response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  def set_vary_header
    return if request.xhr?
    response.headers['Vary'] = 'accept'
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end
