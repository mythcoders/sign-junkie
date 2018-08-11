# frozen_string_literal: true

module Admin
  module NoteHelper
    def edit_note_link(note, current_user)
      { data: { 'clickable-row': '', 'href': edit_admin_customer_note_path(note.customer, note) } } if note.can_edit?(current_user)
    end
  end
end
