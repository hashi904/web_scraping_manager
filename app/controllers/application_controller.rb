class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery

  def render_401(error = nil)
    logger.info "Rendering 401 with exception: #{error.message}" if error

    if request.xhr?
      render json: { error: '404 error' }, status: :unauthorized
    else
      format = params[:format] == :json ? :json : :html
      render template: 'errors/error_404', formats: format,
             status: :unauthorized, layout: 'application', content_type: 'text/html'
    end
  end

  def render_404(error = nil)
    logger.info "Rendering 404 with exception: #{error.message}" if error

    if request.xhr?
      render json: { error: '404 error' }, status: :not_found
    else
      format = params[:format] == :json ? :json : :html
      render template: 'errors/error_404', formats: format,
             status: :not_found, layout: 'application', content_type: 'text/html'
    end
  end

  def render_500(error = nil)
    logger.info "Rendering 500 with exception: #{error.message}" if error

    if request.xhr?
      render json: { error: '500 error' }, status: :internal_server_error
    else
      format = params[:format] == :json ? :json : :html
      render template: 'errors/error_500', formats: format, status: :internal_server_error,
             layout: 'application', content_type: 'text/html'
    end
  end

  private
  # ログインしていないユーザーはredirectする
  # controllerでbefore_actionで設定すること
  # ex) before_action :logged_in_user, only:[:edit, :update, :destroy]
  def logged_in_uder
    redirect_to login_url unless logged_in?
  end
end
