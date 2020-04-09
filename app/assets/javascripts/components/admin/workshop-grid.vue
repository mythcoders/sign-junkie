<script>
import axios from 'axios/dist/axios.min'
import {
  Grid,
  GridToolbar,
  GridNoRecords
} from '@progress/kendo-vue-grid';
import {
  filterBy,
  CompositeFilterDescriptor
} from '@progress/kendo-data-query';

export default {
  name: 'WorkshopGrid',
  components: {
    'Grid': Grid
  },
  data: function() {
    return {
      columns: [{
          field: 'id',
          title: 'ID',
          width: '50px'
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
          format: '{0: yyyy-MM-dd}'
        },
        {
          field: 'type',
          title: 'Type'
        },
        {
          field: 'seating',
          title: 'Seats Available'
        }
      ],
      workshops: []
    };
  },
  mounted() {
    axios.get('/admin/workshops/', {
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => {
        this.workshops = response.data.workshops
      })
  },
  computed: {
    dataItems() {
      return this.workshops
    }
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
  <Grid :data-items="workshops" @rowclick="rowClick" :columns="columns">
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
