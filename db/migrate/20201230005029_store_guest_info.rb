class StoreGuestInfo < ActiveRecord::Migration[6.0]
  def up
    add_column :item_descriptions, :guest_info, :jsonb, null: true

    ItemDescription.all.each do |item|
      next unless item.first_name.present? || item.last_name.present? || item.seat_preference.present?

      item.guest_info = if item.for_child
                          parent = User.find_by_email(item.email)

                          {
                            seat_preference: item.seat_preference,
                            first_name: item.first_name,
                            last_name: item.last_name,
                            parent: {
                              first_name: parent&.first_name,
                              last_name: parent&.last_name,
                              email: item.email
                            }
                          }
                        else
                          {
                            seat_preference: item.seat_preference,
                            first_name: item.first_name,
                            last_name: item.last_name,
                            email: item.email
                          }
                        end

      item.save!
    end
  end

  def down
    remove_column :item_descriptions, :guest_info
  end
end
