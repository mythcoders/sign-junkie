<script>
import Api from 'lib/api'
import {
  Grid,
  GridToolbar,
  GridNoRecords
} from '@progress/kendo-vue-grid';
import {
  filterBy,
  CompositeFilterDescriptor
} from '@progress/kendo-data-query';
import parseDate from '@telerik/kendo-intl';

export default {
  name: 'WorkshopGrid',
  components: {
    'Grid': Grid
  },
  data: function() {
    return {
      items: [],
      columns: [{
          field: 'id',
          title: 'ID',
          width: '50px',
          hidden: true
        },
        {
          field: 'name',
          title: 'Name'
        },
        {
          field: 'seat_purchaseable',
          title: 'Seats'
        },
        {
          field: 'reservation_purchaseable',
          title: 'Reservations'
        },
        {
          field: 'start_date',
          title: 'Date',
          filterable: true,
          format: '{0:yyyy-MM-dd}'
        },
        {
          field: 'type',
          title: 'Type'
        },
        {
          field: 'seating',
          title: 'Seats Available'
        }
      ]
    };
  },
  mounted() {
    Api.adminWorkshops()
      .then(response => {
        this.items = response.data.workshops
      })
  },
  methods: {
    rowClick: function(e) {
      window.location = e.dataItem._link
    }
  }
}
</script>

<template>
<div>
  <Grid :data-items="items" @rowclick="rowClick" :columns="columns">
    <!-- <grid-toolbar>
      <div>
        <button title="Add new" class="k-button k-primary">
          Add new
        </button>
      </div>
    </grid-toolbar> -->
  </Grid>
</div>
</template>
