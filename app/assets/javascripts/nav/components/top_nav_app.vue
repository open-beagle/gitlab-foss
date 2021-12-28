<script>
import { GlNav, GlNavItemDropdown, GlDropdownForm } from '@gitlab/ui';
import TopNavDropdownMenu from './top_nav_dropdown_menu.vue';

export default {
  components: {
    GlNav,
    GlNavItemDropdown,
    GlDropdownForm,
    TopNavDropdownMenu,
  },
  props: {
    navData: {
      type: Object,
      required: true,
    },
  },
  computed: {
    dropdowns() {
      var navData = this.navData;
      var result = [];
      if (navData.primary){
        var projectIndex = navData.primary.findIndex(item => item.id == "project");
        if (projectIndex > -1) {
          var project = navData.primary.splice(projectIndex, 1)[0];
          result.push({
            activeTitle: project.title,
            primary: [],
            secondary: [],
            views: navData.views,
            view: project.view,
            icon: project.icon,
          })
        }
        var groupIndex = navData.primary.findIndex(item => item.id == "groups");
        if (groupIndex > -1) {
          var group = navData.primary.splice(groupIndex, 1)[0];
          result.push({
            activeTitle: group.title,
            primary: [],
            secondary: [],
            views: navData.views,
            view: group.view,
            icon: group.icon,
          })
        }
      }
      result.push({
        activeTitle: navData.activeTitle,
        primary: navData.primary,
        secondary: navData.secondary,
        views: navData.views,
        view: '',
        icon: 'hamburger',
      })
      return result;
    }
  }
};
</script>

<template>
  <gl-nav class="navbar-sub-nav">
    <gl-nav-item-dropdown
      :key="index"
      v-for="(dropdownItem, index) in dropdowns"
      :text="dropdownItem.activeTitle"
      data-qa-selector="navbar_dropdown"
      :data-qa-title="dropdownItem.activeTitle"
      :icon="dropdownItem.icon"
      menu-class="gl-mt-3! gl-max-w-none! gl-max-h-none! gl-sm-w-auto! js-top-nav-dropdown-menu"
      toggle-class="top-nav-toggle js-top-nav-dropdown-toggle gl-px-3!"
      no-flip
      no-caret
    >
      <gl-dropdown-form>
        <top-nav-dropdown-menu
          :primary="dropdownItem.primary"
          :secondary="dropdownItem.secondary"
          :views="dropdownItem.views"
          :view="dropdownItem.view"
        />
      </gl-dropdown-form>
    </gl-nav-item-dropdown>
  </gl-nav>
</template>
