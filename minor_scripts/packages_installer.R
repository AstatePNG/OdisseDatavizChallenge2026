packages <- installed.packages()

is_installed_package <- function(package_name) {
  tryCatch({
    packages[package_name, 1]
    return(TRUE)
  },
  error = function(e) {
    return(FALSE)
  })
}

packages_to_install <- readLines("setup/.packages_list", warn = FALSE)

for (package in packages_to_install) {
  if(!is_installed_package(package)) {
    message("Package ", package, "non installé, début de l'installation...")
    install.packages(package)
    message("Package ", package, " installé.")
  } else {
    message("Package ", package, " déjà installé.")
  }
}