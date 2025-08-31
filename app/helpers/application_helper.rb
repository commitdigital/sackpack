module ApplicationHelper
  def add_button(label:, turbo_frame:, path:)
    link_to(label, path, data: { turbo_frame: }, class: "btn-icon btn-add btn-with-text")
  end
end
