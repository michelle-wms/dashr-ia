library(dash)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(dashCoreComponents)
library(ggplot2)
library(plotly)
library(purrr)


# Set up app frontend
app <- Dash$new(
  #title="Spotify Explorer",
  external_stylesheets=dbcThemes$MINTY
)


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


container <- dbcContainer(
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


app$layout(
  htmlDiv(
    list(navbar, container), style= list("backgroundColor" = "#eeeeef")
)
)



# container <- dbc.Container(
#   [
#     html.Br(),
#     get_tab_section(),
#     html.Footer(
#       [
#         f"(C) Copyright MIT License: Christopher Alexander, Jennifer Hoang, Michelle Wang, Thea Wenxin. ",
#         f"Last time updated on {formatted_date}.",
#       ],
#       style=FOOTER_STYLE,
#     ),
#   ]
# )



app$run_server(debug = T)