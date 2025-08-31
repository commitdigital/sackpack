class ApplicationController < ActionController::Base
  include Authentication
  include Localization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale

  private

  def set_locale
    I18n.locale = session[:language] || detect_browser_language || I18n.default_locale
  end

  def detect_browser_language
    return unless request.env["HTTP_ACCEPT_LANGUAGE"]

    browser_languages = request.env["HTTP_ACCEPT_LANGUAGE"].scan(/[a-z]{2}/)

    (browser_languages & available_locales).first
  end
end
