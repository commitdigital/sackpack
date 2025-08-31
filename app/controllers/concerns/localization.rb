module Localization
  extend ActiveSupport::Concern

  private

  def available_locales
    %w[en ja es]
  end
end
