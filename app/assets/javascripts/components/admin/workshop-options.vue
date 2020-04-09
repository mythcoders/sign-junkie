<script>
export default {
  name: 'WorkshopOptions',
  data: function() {
    return {
      errors: [],
      first_name: '',
      lastName: '',
      email: ''
    }
  },
  methods: {
    validateForm: function(e) {
      this.errors = [];

      if (this.first_name === '' || this.lastName === '') {
        this.errors.push('You forgot to tell us who the gift card is for.')
      }

      if (this.email === '') {
        this.errors.push('We need an email address to associate with this gift card.')
      }

      if (this.errors.length) {
        e.preventDefault();
      } else {
        return true;
      }
    }
  }
}
</script>

<template>
<div>
  <div class='card'>
    <table class='table card-table'>
      <thead>
        <tr>
          <th>Option</th>
          <th>Default Value</th>
          <th>Current Value</th>
        </tr>
      </thead>
      <tfoot>
        <tr>
          <td>
            Are individual seats allowed?
            <small class='form-text text-muted'>Allow customers to purchase individual seats (not associated with a
              reservation) as long as there are enough seats available</small>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            Total seat count
            <small class='form-text text-muted'>Total number of guests that can attend this type of workshop</small>
          </td>
          <td></td>
          <td>
          </td>
        </tr>
        <tr>
          <th class='text-uppercase'>Reservation options</th>
        </tr>
        <tr>
          <td>
            Are reservations allowed?
            <small class='form-text text-muted'>Allow reservations to be booked as long as there are enough seats
              available to meet the reservation minimum seat count</small>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            Are multiple reservations allowed?
            <small class='form-text text-muted'>Allow multiple reservations to be booked by different customers</small>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            Reservations stopped...
            <small class='form-text text-muted'>Number of days before the workshop when reservations are no longer
              accepted</small>
          </td>
          <td></td>
          <td>
            <input class='form-control' disabled='disabled' placeholder='Default' type='text'>
          </td>
        </tr>
        <tr>
          <td>
            Cancel reservation if seating requirements not met?
            <small class='form-text text-muted'>
              Cancel reservations if the minimum number of guests have not met the requirements by the
              registration/payment deadlines
            </small>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            Minimum seat count
            <small class='form-text text-muted'>
              Minimum number of guests that can be on a single reservation
            </small>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            Maximum seat count
            <small class='form-text text-muted'>
              Maximum number of guests that can be on a single reservation. Can not be larger than the total seat count.
            </small>
          </td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            Deposit fee
            <small class='form-text text-muted'>The price it costs for customers to book a reservation</small>
          </td>
          <td></td>
          <td>
            <div class='input-group'>
              <div class='input-group-prepend'>
                <span class='input-group-text'></span>
              </div>
            </div>
          </td>
        </tr>
      </tfoot>
    </table>
  </div>

</div>
</template>
