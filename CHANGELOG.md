#### 2102.11 - January 27, 2022

- Admin Portal Improvements
  - Datepicker
  - Credit Balances report
- Technical features and improvements
  - Updates to system dependencies

#### 2102.10 - January 16, 2022

- Changes
  - Removed the ability to puchase gift cards
- Technical features and improvements
  - Updates to system dependencies

#### 2102.9 - November 10, 2021

- Fixes
  - Grammar in a few locations
- Technical features and improvements
  - Updates to system dependencies

#### 2102.8 - August 24, 2021

- Technical features and improvements
  - Updates to system dependencies

#### 2102.7 - April 12, 2021

- Improvements
  - Project pricing is now displayed everywhere
- Fixes
  - Workshop clone as expected
  - Seats are now properly being voided after a deadline has passed
- Technical features and improvements
  - Updates to system dependencies

#### 2102.6 - March 28, 2021

- Improvements
  - Descriptive, user friendly error messages for failed payments
- Fixes
  - Seat Picker now requires personalizations to be entered
  - Seat Picker sidebar is updated with stencil personalization text
  - An issue that caused an empty invoice to be created on failed payments
- Technical features and improvements
  - Enabled Content Delivery Network (CDN) for certain assets to speed up page loading

#### 2102.5 - March 27, 2021

- Improvements
  - Child projects are not shown under 'Available Projects' for adult-only workshops.
  - Page titles on public facing pages.
- Changes
  - Public and Private policies update
- Admin Portal Improvements
  - Invoices with a Reservation now include the workshop date and a link to the Workshop.
  - Seat Types are shown on the Workshop detail page.
- Fixes
  - Admins are once again able to cancel a reservation or seat.
  - DateTime picker loads existing times correctly.
  - Projects and Workshops clone as expected.
  - The Seat purchased email is no longer sent when a guest on a reservation purchases a seat for themselves.

#### 2102.4 - February 21, 2021

- Fixes
  - An issue that prevented PayPal payments from being made

#### 2102.3 - February 21, 2021

- Improvements
  - Updated help text used in Seat Picker
- Fixes
  - Sales tax is applied to updated seats correctly
  - Loading preselected values in the Seat Picker now works as expected
  - Non-gifted seats can be added to the cart as expected
  - Attempts to fix an issue being caused by a dependency

#### 2102.2 - February 17, 2021

- Fixes
  - Resolved an issue with logging emails that are sent

#### 2102.1 - February 17, 2021

- Improvements
  - Customers are redirected back to their cart after editing a seat from the cart
  - Redesign of Workshop detail page
  - Sizing of project, add-on, and stencils in the Seat Picker
  - Sizing of Invited Guests table in Workshop Planner
  - Show a message in the Invited Guests Table when a seat has been added to someones cart
  - Consistent color usage throughout the Workshop Planner and Seat Picker
  - Grammar and style improvements to the Workshop Planner 'Heads Up!' alert
  - Shopping Cart page slightly redesigned and branded as My Cart
  - Formatting changes for printed Invoices
- Admin Portal Improvements
  - Layout changes to reports
  - Workshop Attendee List report will no longer display cancelled or voided seats
  - Formatting changes for printed Invoices
  - Upcoming Workshops in the Admin Portal are created by
- Fixes
  - Customers should now be able to edit a seat when they should be allowed to
  - Pages in the Admin Portal can be printed again
  - Images should no longer appear stretched in the Seat Picker
  - Customers are no longer allowed to purchase multiple seats at the same time for a guest with the same email address
  - Customers are no longer able to purchase seats for other adults using their own email address
  - Casing of customers email addresses is now ignored
  - The seat purchased email is no longer sent out for seats gifted to children and guests without an email address
  - The Seat Picker will no longer remember the previous add-on or stencil selections when the project is changed
  - The Seat Picker and Stencil detail page in the Admin Portal won't error if a Stencil doesn't have an attached image
  - Turbo now loads only once

#### 2102 - February 7, 2021

- Improvements
  - Redesigned reservation and seat selection experience
  - Redesigned seat management in Workshop Planner
  - Easier for hosts to purchase seats for themselves
  - When purchasing a seat, Guests now explicitly say if a seat belongs to a child
  - When signing in users now have the option to have their email remembered
- Admin Portal Improvements
  - Announcements can be created and displayed to customers on the main page
  - Projects can be configured to allow for multiple stencils or to be only for children
  - All Refunds can now be viewed by an individual screen
  - Search screens filters were changed and links are now more explicit
  - When adding or editing a Workshop, you now have the option to select all projects
  - It's now easier to tell who has paid and who hasn't when looking at seats in a Workshop
  - Removed parent category for stencil categories
  - When creating or updating a record incorrect fields are now highlighted in red
  - Easily resend confirmation instructions to customers that haven't confirmed their account yet
  - Various interface improvements to improve consistency
- Technical features and improvements
  - New technology called Turbo speeds up page rendering
  - Emails are now tracked and delivered by the MythCoders email service, Hermes
  - Rewrote large portions of old JavaScript code
  - Security and other updates

#### 2003.2 - September 10, 2020

- Improvements
  - Projects, Stencils, and Addons can now be marked as Active or Inactive. When inactive, they'll no longer be
    available for purchase.

#### 2003.1 - March 9, 2020

- Technical improvements
  - Revert change that reduced database calls

#### 2003 - March 9, 2020

- Improvements
  - Family friendly workshops allow seats to assigned to a children by a Workshop Host
  - Customers can purchase seats for another customer without providing that customers email address
  - The deposit amount is no longer listed under Hostess Guidelines for Private Workshops
- Admin Portal Improvements
  - When a project or workshop is cloned, the word "copy" is added to the name of the newly created record to clearly
    identify the two.
  - Workshop Guest List report
  - Improved display of Payments and Refunds on an Invoice
  - Improved layout of Workshop detail screen for easier display of workshop and attendee information. Also improved
    layout on smaller screen devices.
  - When viewing a stencil, you can now see which projects are currently associated with it
- Fixes
  - An issue that prevented voiding payments they were successful but they invoice failed to process successfully
- Technical features and improvements
  - Increased efficiency by reducing the number of database calls that are made
  - Security and other updates

#### 2001 - January 19, 2020

- Improvements
  - The stencil personalization textbox only appears for Stencils that can be customized.
  - Additional reminders that customers have 72 hours to confirm their account and that they won't be able to sign-in
    until doing so.
  - Updated the text of the email that is sent to customers when a seat is purchased for them.
  - Background worker to send an email to reservation hosts if they have any guests that have not paid for their
    projects. Runs daily at 06:00 for reservations that have a payment deadline at 23:59.
  - Background worker to send an email to guests who have yet to make their project selection.
    Runs daily at 06:00 for reservations that have a registration deadline at 23:59.
  - Background worker to send an email to users who have yet to confirm their account after signing up.
    Also resends invitations that haven't been accepted after 48 hours. Runs daily at 06:00.
- Admin Portal Improvements
  - Added a New Customers report
  - Tax Periods and Tax Rates can now be added, edited, and deleted
  - Ability to delete customers who don't have any orders or shopping cart items associated to them
  - Report descriptions added to the Reports screen
  - Add-ons associated to a project are now clickable links to the Add-on itself
- Fixes
  - An issue where the reservation payment deadline was at 12:00AM rather than 11:59PM

#### 1912.7 - January 12, 2020

- Simple text updates on the customer side

#### 1912.6 - January 2, 2020

- Sales Tax Liability report

#### 1912.5 - January 1, 2020

- Updated the email addresses that are used to send notifications and order confirmations

#### 1912.4 - December 19, 2019

- Resolved an issue with sending security emails

#### 1912.3 - December 16, 2019

- Improvements and fixes to the refund process, especially for PayPal payments

#### 1912.2 - December 16, 2019

- Improvements
  - On smaller screen devices, the sign in button is showed on the top navigation bar for users who are not signed in.
  - On smaller screen devices, a My Account and shopping cart link are showed on the top navigation bar for users
    who are signed in.
  - Error messages returned when errors occur during the checkout process
  - How the system handles errors during the checkout process
  - Displays the payment/registration deadline when customers are selecting their project for
    seats that apart of a reservation.
  - Background worker to send an email to Customers if an item has left in their cart of longer than 24 hours.
    Reminders are only sent once. Runs daily at 06:00.
- Admin Portal Improvements
  - Table on Dashboard that shows all abandoned carts
  - Redesigned the customer information screen
  - Customer information screen now shows a customers reservations and seats as well as the items still in their
    shopping cart
  - Option to send a reminder email for seats attached to a reservation that haven't made their selection yet
  - Option to remind a user of items left in their cart
  - Ability to configure projects to allow more than one stencil.
    This will be implemented for customers in a future release.
  - Ability to control which stencils are allowed to be customized.
    This will be implemented for customers in a future release.
- Changes
  - Payment and registration deadlines are now at the end of the day (11:59PM) rather than the beginning (12:00AM).
  - When PaymentDeadlineWorkshop and RegistrationDeadlineWorker run they now process records for the previous day
- Fixes
  - Purchasing a seat for someone who does not yet have an account
  - Corrected some messages in the Admin Portal that said å record was created rather than updated successfully

#### 1912.1 - December 7, 2019

- Policy update

#### 1912 - December 4, 2019

- Improvements
  - Reservation Seats are automatically added to a customers cart after making their project/stencil selection
  - Ability to generate Sample Data from the Admin dashboard in review and staging environments
  - When customers are trying to book a seat or reservation to a workshop, the system will show an alert if they
    already have a seat/reservation for that workshop.
- Admin Portal Improvements
  - The amount of an invoice is now displayed on the invoice search screen
- Changes
  - Added a Privacy Policy for customers
  - Quality of data that is generated in review environments
  - Receipts emailed to customers now include links to the Reservation or Seat under My Account
- Fixes
  - When editing a Reservation Seat, the Add-on dropdown is populated with the correct value

#### 1911 - November 26, 2019

- Improvements
  - Redesigned the My Seats screen to show workshop and selected project information. Will also display an message
    saying the seat requires their attention if the project hasn't been selected or paid for. If the host is paying for
    the seat, the system will not tell the guest the seat requires their attention if it hasn't been paid for.
  - Added an alert for a seat where the customer selected their project but has yet to add it to their cart and pay for
    it.
  - Redesigned the seat detail screen when the customer had yet to select their project or stencil
  - Updated the Heads Up alert that hosts see in the Workshop Planner to provide additional information on what needs to
    be done after the minimum number of seats have been added but not yet paid for.
  - Display an alert on the Seat detail page when the seat has already been added to the customers cart
  - Message that is displayed when customers complete their order now has information to help hosts invite their guests
  - Reservation confirmation email now includes links to the Workshop Planner and My Account. Also added additional
    information to help them invite their guests either now or later.
  - Email addresses for customers are validated
  - Workshop Planner now has better formatting on smaller devices
- Changes
  - Customers are redirected to the My Account screen after paying for their order
  - Replaced several uses of the word seat with either project or guest
  - Stopped using the warning beige-looking orange/yellow color in favor of the informational purple color
  - Hosts will no longer see a seat on their reservation after it has been canceled or voided
  - After a host submits the form for adding a new seat to their reservation the save button is disabled to prevent
    multiple clicks
  - Adjusted the use of alert colors based on feedback
- Fixes
  - Sent emails now display images properly
  - Solved a scenario where the system wasn't taking into account the total available seats for the workshop when
    calculating the number of seats that can be added to a reservation
  - Issue that prevented certain Workshop Type fields from being updated
  - Issue that prevented certain Workshop fields from being updated

#### 1910.3 - October 31, 2019

- Resolved an issue where the status of a reservation was being incorrectly calculated
- Fixed “My Orders Page” text that was supposed to be a link to read Workshop Planner and point to the correct page
- Created a .PNG version of the logo that displays properly in emails
- Guidelines was misspelled as “Guidesliness” and has been corrected
- Additional mobile UI improvements
  - Switched the order of images and order form on the workshop selection page
  - Adjustments to improve text sizing on smaller devices across all pages
  - Improved button styling on the shopping cart page
  - Consistent header sizing on all pages

#### 1910.2 - October 18, 2019

- Added the ability to search for customers in the Admin Portal
- Mobile UI improvements
- Resolved an issue that caused several portions of the site to not work properly in Internet Explorer 11 like
  the Braintree UI for entering payment information
- Resolved an issue that prevented gift cards from being purchased

#### 1910 - October 12, 2019

- New features and improvements for customers
  - Customers now have the ability to book reservations to any workshop
  - New look and feel for the sign in, sign up, and forgot password screens on large screen devices
  - Redesigned the look of the My Account screen to reduce the number of tiles
  - Workshop Planner tile
  - Updated policies and guidelines
  - Added a Seats tile to the My Account screen that allows customers to see all seats
    that they've ever bought or been gifted.
  - Redesigned the orders screen where customers view details about their orders, including and payments and refunds
  - Greatly improved the look and feel of emails to be more consistent with the website
  - An email is now sent out when a refund is issued to customers
  - Redesigned the contact us screen with larger buttons and centered text
  - Project names under images on the workshop selection page are now links to project detail page
  - Dropdown menus in the navigation menu now include an arrow to indicate what they are
  - Sorted stencil categories alphabetically on project detail page
  - Decreased font size on the navigation menu
  - Increased the clickable area on the My Account tiles
  - Added business name and address to BrainTree transactions
  - Replaced usages of the color red with purple in order to conserve reds usage of important events/information
- Admin Portal new features and improvements
  - Brand new look and feel with a more responsive design for mobile devices
  - Admin Portal is now reflected as a rocketship rather than a wrench in the navigation bar on the public-facing site
  - Workshop Types - ability to create new types of workshops and customize how customers
    purchase seats and/or reservations
  - Photo Gallery - allows management of the photos that appear on the public-facing site
  - Merged the top navigation bar with a revamped sidebar that includes a quick create menu for various record types
  - Added a user preferences panel with the ability to set a light and dark theme
  - Now displaying additional information about a customers account - failed login attempts, current status and
    date when customer entered that status
  - Added more stats and panels to the dashboard
  - Added the ability to search and sort through records
  - Added a new seating availability metric for workshops to easily tell how many seats are remaining
  - Redesigned the workshop creation and editing screen
  - Added a `Public View` button to the workshop page that opens the workshop selection page that customers use
  - Added the ability to delete unused customer credits
  - Cloning a workshop will also clone any attached images
  - Images are displayed in a consistent table that shows the date the image was uploaded. Also provides the
    ability to easily download the image
  - When viewing a project, the `Allow option to select no stencil` is displayed as
    `Plain (no stencil or personalization)` in the same spot as the create and edit screen
  - Alerts and error messages are displayed as a temporary alert towards the top of the screen
  - Seats and reservations can now be canceled from the Workshop detail page
  - Added the ability to forfeit reservation deposits
  - Renamed Add-ons to Project Add-ons
  - Tax Periods and Rates can be seen but not yet edited
  - Added a help section that will be expanded on in future releases
- Technical features and improvements
  - Background Worker to clean up old items in user carts. Runs daily at 00:15.
  - Background Worker to void reservations and seats that don't meet payment requirements. Runs daily at 00:30.
  - Background Worker to void reservations and seats that don't meet registration requirements. Runs daily at 01:00.
  - Background Worker to refund reservation deposits 48 hours after the workshop ended. Runs daily at 02:00.
  - Background Worker to process refunds as they are requested.
  - Background Workers for processing reservation and seat cancelation and voids as they are requested.
  - Security and other updates

#### 1908.1 - October 6, 2019

- Fixes
  - An issue that prevented password reset emails from being sent

#### 1908 - August 17, 2019

- Features
  - Option for projects to be purchased with no stencil
- Improvements
  - Stencils are sorted alphabetically
  - In the Admin Portal, the name of attendees are shown on the workshop detail page
- Changes
  - Ability to introduce new features in a more seamless experience

#### 1906.9 - July 13, 2019

- Changes
  - System backend

#### 1906.8 - July 12, 2019

- Changes
  - System logging

#### 1906.7 - July 10, 2019

- Changes
  - Email configuration
- Fixes
  - Grammar for text that appears when reserving a seat for someone else

#### 1906.6 - July 4, 2019

- Improvements
  - Creating Customers and Employees in the Admin Portal
  - When a customer credit is created in the Admin Portal, the customer will now receive the same email that they would
    have received if a gift card had been purchased for them
  - Security enhancements

#### 1906.5 - July 3, 2019

- Improvements
  - HTML properties that appear when site links are shared
- Fixes
  - Grammar for text that appears when checking out

#### 1906.4 - June 30, 2019

- Improvements
  - The experience when creating an account for the first time
  - Text for gift card notification emails
- Fixes
  - Accept link in user invitations was an invalid link

#### 1906.3 - June 29, 2019

- Fixes
  - Small font color change
  - Emails were not being sent properly in all environments
  - Skylight integration is now working properly

#### 1906.2 - June 29, 2019

- Improvements
  - More formating for tablets and mobile devices
  - Increased logging to help with debugging issues
- Fixes
  - Issue that prevented the creation of Stencils

#### 1906.1 - June 27, 2019

- Features
  - Receipts for orders placed
  - Email notifications for gift card recipients
  - Email notifications for orders canceled to admins and the customer
- Improvements
  - Multiple screens properly formatted for tablets and mobile devices
  - Checkout experience with gift cards
- Fixes
  - Customers were unable to book another seat for themselves if they had cancel a prior order

#### 1906 - June 18, 2019

- Features
  - Gift Cards
  - Ability to cancel orders and have payments refunded as credits
  - My Account for customers
  - Acknowledgments for public seats
  - Customer invites
  - Policies and guidelines for customers
  - Projects, Stencils, and Add-ons are viewable by customers
  - Coming soon page for reservations
- Changes
  - Designs are now Stencils
  - Orders are now Invoices
  - Tax Rates are stored in the database
  - Add-ons are managed independently and associated to Projects
  - Projects now have material and instructional prices
  - Seat price is now based entirely on the project selected
  - Prevented customer from booking multiple seats to the same workshop
  - Custom stencils have been redesigned
  - Removed quantity dropdown from workshop selection page
- Improvements
  - Sorted projects, stencils, stencil categories, and workshops alphabetically in various spots through out the website
  - Redesigned shopping cart and checkout experience
  - Stencils are grouped by category when selecting a workshop
  - Sales tax calculation
  - Button to preview selected stencils
  - Validations when creating Workshops
  - Multiple backend services
