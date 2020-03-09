# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  setup do
    create(:tax_rate)
  end

  # describe '#for' do
  #   # pending 'needs fixed'
  #
  #   subject { Cart.for(user1) }
  #   let(:user1) { create(:customer) }
  #   let(:user2) { create(:customer) }
  #   let(:seat1) { create(:cart_seat, user: user1) }
  #   let(:seat2) { create(:cart_seat, user: user2) }
  #
  #   it 'returns records based on the user' do
  #     expect(subject).to include(seat1)
  #     expect(subject).to_not include(seat2)
  #   end
  # end

  # describe '#as_of' do
  #   # pending 'needs fixed'
  #
  #   subject { Cart.as_of(Time.zone.now - 12.hours) }
  #   let(:seat1) { create(:cart_seat) }
  #   let(:seat2) { create(:cart_seat, created_at: Time.zone.now - 25.hours) }
  #
  #   it 'returns records based on when requested' do
  #     expect(subject).to include(seat2)
  #   end
  # end

  # describe '#for_shop' do
  #   # pending 'needs fixed'
  #
  #   subject { Cart.for_shop(seat1.workshop_id) }
  #   let(:seat1) { create(:cart_seat) }
  #   let(:seat2) { create(:cart_seat) }
  #
  #   it 'includes seats for the requested workshop' do
  #     expect(subject).to include(seat1)
  #     expect(subject).to_not include(seat2)
  #   end
  # end

  # describe '#non_gift_seat' do
  #   # pending 'needs fixed'
  #
  #   subject { Cart.non_gift_seat }
  #   let(:seat1) { create(:cart_seat) }
  #   let(:seat2) { create(:gifted_cart_seat) }
  #
  #   it 'includes seats that are gifts' do
  #     expect(subject).to include(seat1)
  #   end
  #
  #   it 'does not include seats that weren\'t gifts' do
  #     expect(subject).to_not include(seat2)
  #   end
  # end

  # describe '#gifted_seats' do
  #   # pending 'needs fixed'
  #
  #   subject { Cart.gifted_seats(seat1.email) }
  #   let(:seat1) { create(:cart_seat) }
  #   let(:seat2) { create(:cart_gift_card) }
  #
  #   it 'returns seats that have been gifted' do
  #     expect(subject).to include(seat1)
  #     expect(subject).to_not include(seat2)
  #   end
  # end

  # context 'when creating a' do
  #   let(:user) { create(:customer) }
  #   let(:workshop) { create(:bookable_workshop) }
  #
  #   describe 'new seat' do
  #     subject { Cart.new_seat(user, workshop, cart_params) }
  #     let(:project) { workshop.projects.first }
  #     let(:stencil) { project.stencils.first }
  #     let(:addon) { project.addons.first }
  #     let(:cart_params) { { project_id: project.id, stencil_id: stencil.id } }
  #
  #     shared_examples 'raises ProcessError' do
  #       it 'prevents record from being created' do
  #         expect { subject.save }.to raise_error(ProcessError)
  #       end
  #     end
  #
  #     it 'has the correct type' do
  #       expect(subject.item_type).to eq('seat')
  #       expect(subject.seat?).to be true
  #     end
  #
  #     it 'has pricing based on selected project' do
  #       expect(subject.nontaxable_amount).to eq(project.instructional_price)
  #       expect(subject.taxable_amount).to eq(project.material_price)
  #     end
  #
  #     it 'includes selected workshop info' do
  #       expect(subject.workshop_id).to eq(workshop.id)
  #       expect(subject.workshop_name).to eq(workshop.name)
  #     end
  #
  #     it 'includes selected project info' do
  #       expect(subject.project_id).to eq(project.id)
  #       expect(subject.project_name).to eq(project.name)
  #     end
  #
  #     it 'includes selected stencil info' do
  #       expect(subject.stencil_id).to eq(stencil.id)
  #       expect(subject.stencil_name).to eq(stencil.name)
  #     end
  #
  #     it 'does not allow projects from other workshops' do
  #       cart_params[:project_id] = create(:project).id
  #       expect { Cart.new_seat(user, workshop, cart_params) }.to raise_error(ActiveRecord::RecordNotFound)
  #     end
  #
  #     it 'does not allow stencils from other workshops' do
  #       cart_params[:stencil_id] = create(:stencil).id
  #       expect { Cart.new_seat(user, workshop, cart_params) }.to raise_error(ActiveRecord::RecordNotFound)
  #     end
  #
  #     context 'as a gift' do
  #       subject { Cart.new_seat(user, workshop, cart_params.merge(person)) }
  #       let(:person) { random_person }
  #
  #       it 'includes gift recipient info' do
  #         expect(subject.first_name).to eq(person[:first_name])
  #         expect(subject.last_name).to eq(person[:last_name])
  #         expect(subject.email).to eq(person[:email])
  #       end
  #     end
  #
  #     context 'that includes an addon' do
  #       subject { Cart.new_seat(user, workshop, cart_params.merge(addon_id: addon.id)) }
  #       let(:addon) { project.addons.first }
  #
  #       it 'includes the addons price' do
  #         expect(subject.taxable_amount).to eq(addon.price + project.material_price)
  #       end
  #
  #       it 'includes the addons info' do
  #         expect(subject.addon_id).to eq(addon.id)
  #         expect(subject.addon_name).to eq(addon.name)
  #       end
  #     end
  #
  #     context 'that has a seating preference' do
  #       subject { Cart.new_seat(user, workshop, cart_params.merge(seating: 'someone')) }
  #
  #       it 'includes the seating info' do
  #         expect(subject.seat_preference).to eq('someone')
  #       end
  #     end
  #
  #     context 'that has a personilized stencil' do
  #       subject { Cart.new_seat(user, workshop, cart_params.merge(stencil: 'something')) }
  #
  #       it 'includes the addons info' do
  #         expect(subject.stencil_personalization).to eq('something')
  #       end
  #     end
  #
  #     context 'that has already been booked' do
  #       subject { Cart.new_seat(seat.customer, seat.workshop, cart_params) }
  #       let(:seat) { create(:seat, :paid) }
  #       let(:cart_params) { { project_id: seat.project_id, stencil_id: seat.stencil_id } }
  #
  #       include_examples 'raises ProcessError'
  #     end
  #
  #     context 'that has already been added to cart' do
  #       subject { Cart.new_seat(cart.user, cart.workshop, cart_params) }
  #       let(:cart) { create(:cart_seat) }
  #       let(:cart_params) { { project_id: cart.project_id, stencil_id: cart.stencil_id } }
  #
  #       include_examples 'raises ProcessError'
  #
  #       context 'by another user as a gift' do
  #         subject { Cart.new_seat(customer, cart.workshop, cart_params) }
  #         let(:cart) { create(:gifted_cart_seat) }
  #         let(:customer) { create(:customer, email: cart.email) }
  #         let(:cart_params) { { project_id: cart.project_id, stencil_id: cart.stencil_id } }
  #
  #         include_examples 'raises ProcessError'
  #       end
  #     end
  #   end
  #
  #   describe 'new gift card' do
  #     subject { Cart.new_gift_card(user, cart_params.merge(person)) }
  #     let(:person) { random_person }
  #     let(:cart_params) { { amount: 25.00 } }
  #
  #     it 'is not taxable' do
  #       expect(subject.taxable_amount).to eq(0.00)
  #     end
  #
  #     it 'is for the amount requested' do
  #       expect(subject.nontaxable_amount).to eq(cart_params[:amount])
  #     end
  #
  #     it 'includes persons info' do
  #       expect(subject.first_name).to eq(person[:first_name])
  #       expect(subject.last_name).to eq(person[:last_name])
  #       expect(subject.email).to eq(person[:email])
  #     end
  #   end
  #
  #   describe 'new reservation' do
  #     subject { Cart.new_reservation(user, workshop, cart_params) }
  #     let(:cart_params) { { amount: 25.00 } }
  #
  #     it 'is not taxable' do
  #       expect(subject.taxable_amount).to eq(0.00)
  #     end
  #
  #     it 'is priced based on selected workshop' do
  #       expect(subject.nontaxable_amount).to eq(workshop.reservation_price)
  #     end
  #   end
  # end
end
