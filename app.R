library(dash)
# library(dashHtmlComponents)
# library(dashBootstrapComponents)
# library(dashCoreComponents)
library(ggplot2)
library(plotly)
library(purrr)
#library(lubridate)
library(dplyr)


# read data ------

df <- read.csv('data/raw/spotify.csv')
df <- na.omit(df)

df$date <- as.Date(df$track_album_release_date, format = "%Y-%m-%d")



# Set up app frontend -----
app <- Dash$new(
  external_stylesheets = dbcThemes$MINTY
)

app$title("Spotify Explorer App")


# navbar ------

NAV_STYLE <- list(
  "height" = "50px",
  "fontSize" = "large"
)

navbar <- dbcNavbar(
  dbcContainer(
    list(
      htmlA(
        dbcRow(
          list(
            dbcCol(htmlImg(src="https://www.freepnglogos.com/uploads/spotify-logo-png/spotify-icon-marilyn-scott-0.png", height="50px")),
            dbcCol(dbcNavbarBrand("Spotify Explorer", className="py-10"))
          ) , 
          align="center",
          className="g-0",
          style=NAV_STYLE
        )
      )
    )
  )
)


# container -- 

FOOTER_STYLE <- list(
  "position"="fixed",
  "bottom" = 0,
  "left"=0,
  "right"=0,
  "height"="25px",
  "padding"="3px 0 0 5px",
  "backgroundColor"="green",
  "color"="white",
  "fontSize"="small"
)


footer <- dbcContainer(
  list(
    htmlBr(),
    #get_tab_section(),
    htmlFooter(
      list(
        "(C) Copyright MIT License: Christopher Alexander, Jennifer Hoang, Michelle Wang, Thea Wenxin. "
      ), 
      style=FOOTER_STYLE
    )
  ) 
)




# get_artist_section widget + plot

sidebar_widgets <- dbcCol(
  children=list(
    htmlH2("Overview", className="display-30"),
    htmlH6(
      "Welcome! This is a dashboard displaying trends in popularity of artists, \
                genres and song types in Spotify. Happy exploring!",
      className="display-30",
    ),
    htmlBr(),
    htmlBr(),
    # htmlH5("Genre:"),
    # dccDropdown(
    #   id="genre",
    #   value="pop",
    #   style=list("border-width"="0", "width"="100%"),
    #   options=unique(df$playlist_genre) %>%
    #     purrr::map(function(col) list(label = col, value = col))
    # ),
    htmlBr(),
    htmlBr(),
    htmlBr(),
    htmlBr(),
    htmlBr(),
    htmlH5("Artist Name:"),
    dccDropdown(
      id="artist_selection",
      value="Ed Sheeran",
      style=list("border-width"="0", "width"="100%"),
      options=unique(df$track_artist) %>%
        purrr::map(function(col) list(label = col, value = col))
      )
  ),
  width=list('offset'=1, 'size'=3)
)

# app layout ----

app$layout(
  dbcRow(
    children = list(
      navbar,
      sidebar_widgets,
      dbcCol(
        list(dccGraph(id='artist_trend_plot')), width=list('offset'=0.5)
        ),
      footer
    ),
    style= list("backgroundColor" = "#eeeeef")
  )
)

# app$layout(
#   dbcContainer(
#     list(
#       dccGraph(id='artist_trend_plot'),
#       dccDropdown(
#         id="artist_selection",
#         value="Ed Sheeran",
#         style=list("border-width"="0", "width"="100%"),
#         options=unique(df$track_artist) %>%
#           purrr::map(function(col) list(label = col, value = col))
#         )
#     )
#   )
# )

app$callback(
  output('artist_trend_plot', 'figure'),
  list(input('artist_selection', 'value')),
  function(artist) {

    df_artist <- df[df$track_artist == artist, ]

    p <- ggplot(df_artist, aes(x= date, y=track_popularity)) +
      geom_line(stat='summary', fun=mean) +
      labs(x='Date', y='Avg track Popularity') +
    scale_x_date(date_labels =  "%b-%Y") +
      ggthemes::scale_color_tableau()

    ggplotly(p)
  }
)



# app server --------------

app$run_server(host = '0.0.0.0')