class StoreGuestInfo < ActiveRecord::Migration[6.0]
  def up
    add_column :item_descriptions, :owner, :jsonb, null: true

    ItemDescription.all.each do |item|
      next unless item.first_name.present? || item.last_name.present? || item.email.present?

      if item.gift_card?
        item.owner = {
          first_name: item.first_name,
          last_name: item.last_name,
          email: item.email
        }
      elsif item.seat?
        item.owner = if item.for_child
          parent = User.find_by_email(item.email)

          {
            type: "child",
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
            type: "adult",
            first_name: item.first_name,
            last_name: item.last_name,
            email: item.email
          }
        end
      end

      item.save!
    end
  end

  def down
    remove_column :item_descriptions, :owner
  end
end
