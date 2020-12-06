function toggleColorScheme(colorScheme) {
  if (colorScheme == 'light') {
    document.cookie = 'apollo_ui_theme=light; path=/ '
  } else if (colorScheme == 'dark') {
    document.cookie = 'apollo_ui_theme=dark; path=/ '
  }
}

function saveUserPreferences() {
  toggleColorScheme(document.querySelector('[name="apollo_ui_theme"]:checked').value)
  location.reload();
}