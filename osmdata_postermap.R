library(osmdata)
library(sf)
library(tidyverse)
library(leaflet)

nsw_coast <- st_read(dsn = "E:/Coding Tutorials-Learning/NSW_bushfire_mapping/vegetationnswextantnativevegetationv2",
                     layer = "cstauscd_r")
nsw_coast <- filter(nsw_coast, FEAT_CODE == "mainland" & STATE_CODE == 3) #filter the australian wide map to NSW

# osmdata::available_features()
# osmdata::available_tags("boundary")

streets <- getbb("Wollongong Australia")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) %>%
  osmdata_sf()

small_streets <- getbb("Wollongong Australia")%>%
  opq()%>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "unclassified",
                            "service", "footway")) %>%
  osmdata_sf()

# country <- getbb("Wollongong Australia") %>%
#   opq() %>%
#   add_osm_feature(key = "boundary",
#                   value = c("aboriginal_lands", "administrative",
#                             "historic", "marker",
#                             "postal_code", "protected_area")) %>%
#   osmdata_sf()


# ggplot()+
#   geom_sf(data = country$osm_lines,
#           inherit.aes = FALSE,
#           colour = "black",
#           size = .4,
#           alpha = .6)


river <- getbb("Wollongong Australia")%>%
  opq()%>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "#7fc0ff",
          size = .4,
          alpha = .8) +
  geom_sf(data = small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "#ffbe7f",
          size = .4,
          alpha = .6) +
  # geom_sf(data = river$osm_lines,
  #         inherit.aes= FALSE,
  #         color = "steelblue",
  #         size = .4,
  #         alpha = .6)+
  # geom_sf(data = nsw_coast,
  #         inherit.aes = FALSE,
  #         color = "#ffbe7f",
  #         size = .4,
  #         alpha = .8)+
  # coord_sf(xlim = c(151.89944, 151.79164),
  #          ylim = c(-34.52551, -34.60636),
  #          expand = FALSE) +
 theme_void()+
  theme(
    plot.background = element_rect(fill = "#282828")
  )


ggsave("map.png", width = 6, height = 6)


leaflet() %>% addTiles()  %>% 
  setView(lng = -0.106831, lat = 51.515328, zoom = 18) %>%
  addEasyButton(easyButton(
    states = list(
      easyButtonState(
        stateName="unfrozen-markers",
        icon="ion-toggle",
        title="Get Bounding box",
        onClick = JS("
                     function(btn, map) {
                     alert(map.getBounds().getEast());
                     alert(map.getBounds().getWest());
                     alert(map.getBounds().getNorth());
                     alert(map.getBounds().getSouth());
                     }")
      )
        )
        )
        )



q <- opq(bbox = c(151.18638038635257,-33.88048985986804,151.22796535491943, -33.853096342414624))
syd <- q %>%
  add_osm_feature(key = "highway")

osmdata_xml(syd, filename = "sydney.osm")
sydney <- st_read("sydney.osm", layer = "lines")


ggplot(sydney) +
  geom_sf()
