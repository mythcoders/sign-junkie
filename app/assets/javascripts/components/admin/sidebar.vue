<script>
export default {
  name: 'Sidebar',
  props: {
    currentView: {
      required: true
    },
    userRole: {
      required: true
    }
  },
  methods: {
    showITOperators: function() {
      return this.userRole === 'operator';
    }
  }
}
</script>

<template>
<div>
  <nav class='d-print-none' id='sidebar'>
    <div class='container-fluid'>
      <button class='navbar-toggler'>
        <span class='navbar-toggler-icon'></span>
      </button>
      <div class='collapse navbar-collapse' id='navbarVertical'>
        <h6 class='navbar-heading mb-n1'>Your Business</h6>
        <ul class='navbar-nav mb-md-3'>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
        </ul>
        <h6 class='navbar-heading mb-n1'>Configuration</h6>
        <ul class='navbar-nav mb-md-3'>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
          <li class='nav-item'>
          </li>
        </ul>
        <div class='mt-auto'></div>
        <div class='navbar-user' id='sidebarUser'>
          <a class='navbar-user-link'>
            <span class='icon'>
              <i class='fad fa-globe-americas'></i>
            </span>
          </a>
          <div class='dropup'>
            <a aria-expanded='false' aria-haspopup='true' class='dropdown-toggle' data-toggle='dropdown' href='#'
               id='sidebarIconCopy' role='button'>
              <div class='avatar avatar-sm'>
                <span class='avatar-title rounded-circle'></span>
              </div>
            </a>
            <div aria-labelledby='sidebarIconCopy' class='dropdown-menu'>
              <a class='dropdown-item'>
                My Profile
              </a>
              <a class='dropdown-item'>
                Preferences
              </a>
              <a class='dropdown-item'>
                Support
              </a>
              <hr class='dropdown-divider'>
              <a class='dropdown-item'>
                About
              </a>
              <a class='dropdown-item'>
                Sign Out
              </a>
            </div>
          </div>
          <div class='dropup'>
            <a aria-expanded='false' aria-haspopup='true' class='dropdown-toggle' data-toggle='dropdown' href='#'
               id='sidebarNewRecord' role='button'>
              <span class='icon text-muted'>
                <i class='fad fa-plus-circle'></i>
              </span>
            </a>
            <div aria-labelledby='sidebarNewRecord' class='dropdown-menu dropdown-menu-right'>
              <a class='dropdown-item'>
                <i class='fad fa-address-book'></i>
                Customer
              </a>
              <a class='dropdown-item'>
                <i class='fad fa-sign'></i>
                Project
              </a>
              <a class='dropdown-item'>
                <i class='fad fa-swatchbook'></i>
                Stencil
              </a>
              <a class='dropdown-item'>
                <i class='fad fa-toolbox'></i>
                Workshop
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </nav>
</div>
</template>
