# frozen_string_literal: true

# module Hermes
#   class Mail
#     attr_reader :to, :cc, :bcc, :subject, :body, :from, :content_type

#     def initialize(*args, &block)
#       @content_type = :html

#       # Support both builder styles:
#       #
#       #   Mail.new do
#       #     to 'recipient@example.com'
#       #   end
#       #
#       # and
#       #
#       #   Mail.new do |m|
#       #     m.to 'recipient@example.com'
#       #   end
#       if block_given?
#         if block.arity.zero? || (RUBY_VERSION < '1.9' && block.arity < 1)
#           instance_eval(&block)
#         else
#           yield self
#         end
#       end

#       self
#     end

#     def self.new(*args, &block)
#       Message.new(args, &block)
#     end

#     def self.new_from_rails!(mail)
#       # :recipient_address => mail.to.first,
#       # :recipient_name    => mail[:to].display_names.first,
#       # :sender_address    => mail.from.first,
#       # :sender_name       => mail[:from].display_names.first,
#       # :reply_to_address  => mail.reply_to ? mail.reply_to.first : nil,
#       # :reply_to_name     => mail.reply_to ? mail[:reply_to].display_names.first : nil
#       new(subject: mail.subject,
#           body: mail.body,
#           to: mail.to,
#           bcc: mail.bcc,
#           cc: mail.cc)
#     end

#     def add_recipient()
#     end

#     def add_bcc_recipient()
#     end

#     def add_cc_recipient()
#     end
#   end
# end
