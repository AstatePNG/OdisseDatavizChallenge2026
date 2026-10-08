library(tidyverse)
library(sf)
library(leaflet)

sections_list <- read_csv("data/sections_url.csv")

load_map_sections <- function(sections = "departements") {
    path <- sections_list |> 
        filter(SECTION == sections) |> 
        slice_head() |> 
        pull(URL)

    st_read(path, quiet = TRUE) |> 
        st_transform(4326) |> 
        select(code, nom)
}

base_map <- function(sections, lng = 2.5, lat = 46.5, zoom = 5) {
    leaflet(sections, options = leafletOptions(minZoom = 3)) |>
        addTiles() |>
        setView(lng, lat, zoom)
}

sectionned_map <- function(data, var, col_code = "code", sections,
                            map = NULL, palette = "viridis",
                            domain = NULL, title = var,
                            units = "", dec = 1) {
    stopifnot(col_code %in% names(data), var %in% names(data))

    map_data <- data |> 
        transmute(code = as.character(.data[[col_code]]), value = .data[[var]]) |> 
        right_join(sections, join_by(code)) |> 
        st_as_sf()

    if (is.null(domain)) domain <- range(map_data$value, na.rm = TRUE)
    pal <- colorNumeric(palette, domain = domain, na.color = "#cccccc")

    labels <- ifelse(
        is.na(map_data$value),
        paste0(var, " : no data"),
        paste0(var, " : ", formatC(map_data$value, format = "f", digits = dec), " ", units)
    )

    if (is.null(map)) map <- base_map(sections)

    map |> 
        clearShapes() |> 
        clearControls() |> 
        addPolygons(
            data = map_data,
            fillColor = ~pal(value), fillOpacity = 0.85,
            color = "white", 
            weight = 1,
            label = labels,
            highlightOptions = highlightOptions(weight = 3, color = "#444", bringToFront = TRUE)
        ) |> 
        addLegend(
            pal = pal,
            values = domain,
            title = title,
            position = "bottomright",
            opacity = 0.9
        )
}
