class LanguagesController < ApplicationController
  allow_unauthenticated_access

  def update
    if available_locales.include?(params[:language])
      session[:language] = params[:language]
    end

    redirect_back(fallback_location: root_path)
  end
end
