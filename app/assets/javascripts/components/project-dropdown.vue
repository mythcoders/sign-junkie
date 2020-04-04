<script>
const utils = require('utils.js')

export default {
  name: 'ProjectDropdown',
  props: {
    projects: {
      required: true
    },
    guestType: {
      required: true
    }
  },
  data: function() {
    return {
      project: {}
    }
  },
  methods: {
    applicableProjects: function() {
      if (utils.isObjectEmpty(this.projects)) {
        return [];
      } else if (this.guestType === 'child') {
        return this.projects;
      } else {
        return this.projects.filter(function(project) {
          return project.prohibit_adult_purchases == false
        });
      }
    }
  },
  watch: {
    project: function(value) {
      this.$emit('update-project', value)
    }
  }
}
</script>

<template>
<div>
  <div class="form-row">
    <div class="form-group col">
      <i class="fas fa-sign text-primary fa-fw"></i>
      <label for="project">Project</label>
      <select class="form-control custom-select" id="project_id" v-model="project">
        <option v-if="projects && projects.length == 0" :value='{}'>No projects for this workshop</option>
        <option :value='{}'>- Please select a project -</option>
        <option v-for="project in applicableProjects()" :value="project">
          {{ project.name }}
        </option>
      </select>
    </div>
  </div>
</div>
</template>
