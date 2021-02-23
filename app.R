###############################
#                             #
#   RamPoll 2020 shiny App    #
#                             #
###############################

# App: https://sarah-fondots.shinyapps.io/RamPoll2020App/
# Github repository: https://github.com/ActaeaPachypoda/RamPollApp2020

# load packages
library(shiny)
library(tidyverse)
library(ggplot2)
library(rio)
library(RColorBrewer)
library(zipcodeR)
library(rpivotTable)
library(shinythemes)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
library(sf)
library(USAboundaries)
library(htmltools)
library(DT)

## Data import and manipulation ----

# poll.data <- import("Data/Ram-Poll-2020-text.csv")
# zipcode <- search_state('PA')
# consentData <- poll.data %>% filter(INFCONS == "I agree")
# consentData <- consentData %>% mutate(SCHOOL.ZIP = as.character(SCHOOL.ZIP))
# consentData <- consentData %>% replace(.,is.na(.),"No Answer")
# consentData1 <- select(consentData,
#                        TRUST, REG, PARTY, VOTENOV, ADDRESS, MODE, VOTEPRES, RATEGOV, RATEPRES, IDEO, CANNABIS, WAWA,
#                        FIRSTGEN, COUNTY, ZIP, MOBILE, RACE, REL, SEX, GENDID, NUDGE, CAMPUS)
# consentData1 <- consentData1 %>% drop_na()

# Select values for pivot table
# pivotData <- select(consentData,
#                     CAMPUS:PARTY,
#                     VOTENOV:VOTEPRES,
#                     RATEGOV:COUNTY,
#                     RACE,
#                     REL,
#                     SEX:GENDID,
#                     REGION)
# pivotData1 <- pivotData %>% drop_na()


poll.data  <- readxl::read_xlsx("data/Ερωτηματολόγιο Διπλωματικής Εργασίας (Απαντήσεις) (1).xlsx")

raw_questions = colnames(poll.data)

questions_map = c("time", "terms",                                 # 2
                  "O1", "O2.1", "O2.2.1", "O2.2.2", "O2.2.3",      # 5
                  "N1", "N1.2", "N1.3", "N1.4", "N1.5", "N1.6", "N1.7.1", "N1.7.2", "N1.7.3", "N1.7.4", # 10
                  "N1.8", "N1.9.1", "N1.9.2", "N1.9.3", "N2.1", "N2.2", "N2.2.1", "N2.3", "N2.3.1", # 9
                  "N2.4", "N2.4.1", "N2.5.1", "N2.5.2", "N2.5.3", "N2.5.4", "N2.6", "N2.7", # 8
                  "N3.1", "N3.2", "N3.3", "N3.4", "N3.5", "N3.6", "N3.7", "N3.8.1", "N3.8.2", "N3.8.3", # 10
                  "D1", "D2", "D3", "D4", "D4.1", "D5", "D6", "D7.1", "D7.2", "D7.3", "D7.4", # 11
                  "D8","D9") # 2

colnames(poll.data) <- questions_map
  
pivotData <- poll.data

#leaflet variables
# state <- us_boundaries(states = "Pennsylvania")
# bbox <- st_bbox(state) %>% as.vector()

# add geocoding to datatable for maps
# pa.home.data <- inner_join(consentData,zipcode, by=c("ZIP"="zipcode"))
# pa.school.data <- inner_join(consentData,zipcode, by=c("SCHOOL.ZIP"="zipcode"))

# color palette for map (voter zip)
# party.pal <- colorFactor(
#   palette = c("#0015BC", "#FF0000", "#800A5E", "#6ea300"),
#   domain = consentData$PARTY
# )

# color function for leaflet icons (college)
# getColor <-
#   function(pa.school.data) {
#     sapply(pa.school.data$PARTYNUM, function(PARTYNUM) {
#       if(PARTYNUM == 1){"blue"}
#       else if(PARTYNUM == 2){"red"}
#       else if(PARTYNUM == 3){"purple"}
#       else if(PARTYNUM == 4){"yellow"}
#       else if(PARTYNUM == 5){"grey"}
#       else {"#FFFFFF"}
#     })
#   }

# icon function to adjust leaflet icons (college)
# icons <- awesomeIcons(
#   icon = "graduation-cap",
#   library = 'fa',
#   iconColor = '#FFFFFF',
#   markerColor = getColor(pa.school.data)
# )

# labels for leaflet icons (college)
# labels <- sprintf(
#   "<strong>Respondent</strong><br/>
#   <strong>Campus: </strong>%s<br/>
#   <strong>Registered: </strong>%s<br/>",
#   consentData$CAMPUS,
#   consentData$REG
# ) %>%
#   lapply(htmltools::HTML)

# Palettes for bar charts (remember to do them alphabetically)
# Democrat, Independent, No Answer, Republican, Something Else
# PARTY = c("#0015BC", "#6F0B5E", "#DE0100", "#FFF655")
# Female, Male, No Answer
# SEX = c("#D870AD","#4B89DC")
# Bloomsburg, California, Clarion, East Stroudsburg, Edinboro, Indiana, Kutztown, Lock Haven, Mansfield, Millersville, No Answer,
# Shippensburg, Slippery Rock, West Chester

# CAMPUS = c("#79001F", "#E8261F", "#20377D", "#DD1A35", "#DE1E27", "#A80C30", "#77253A", "#AA1835", "#A91A2D", "#231F20",
#            "#EE293D", "#00674E", "#621B7B")


# Define UI for application
ui <- navbarPage(
  "Mathematics Teachers Survey 2021",
  # theme = shinytheme("darkly"),  # <--- To use the default theme, comment this out
  
  # 1
  tabPanel("Bar Charts",
           sidebarPanel(
             selectInput("select", label = h5("Please select your question"), 
                         choices = list("How much do you trust public opinion polls?" = "TRUST", 
                                        "Some people are registered to vote in Pennsylvania, and many others are not. Are you currently registered to vote in Pennsylvania?" = "REG", 
                                        "Are you currently registered as a Republican, a Democrat, an Independent, or something else?" = "PARTY",
                                        "What would you say are the chances that you will vote in the November election?" = "VOTENOV",
                                        "At which address are you registered to vote?" = "ADDRESS" ,
                                        "If you intend to vote, how will you vote?" = "MODE" ,
                                        "If the 2020 election for President of the United States were being held today, for whom would you vote?" = "VOTEPRES" ,
                                        "How would you rate the way that Tom Wolf is handling his job as Governor?" = "RATEGOV",
                                        "How would you rate the way that Donald Trump is handling his job as president?" = "RATEPRES",
                                        "Politically speaking, do you consider yourself to be a liberal, a moderate, or a conservative?" = "IDEO",
                                        "Do you think the Pennsylvania state legislature should pass a law to make marijuana legal, or not?" = "CANNABIS",
                                        "Pick one: Sheetz or Wawa." = "WAWA",
                                        "Are you a first generation college student?" = "FIRSTGEN",
                                        "In which county is your permanent residence?" = "COUNTY",
                                        "What is the zip code at your permanent residence?" = "ZIP",
                                        "How long have you lived at your permanent residence?" = "MOBILE",
                                        "Which of the following categories best describes your racial or ethnic background?" = "RACE",
                                        "What is your religious affiliation, if any?" = "REL" ,
                                        #"If you answered Christian to the previous question, are you an evangelical Christian?" = EVANG,
                                        "What is your legal sex?" = "SEX",
                                        "To which gender identity do you most identify?" = "GENDID",
                                        "If you are not registered to vote, you can still do so until October 19th. Registering to vote online is easy at VotesPA.com. It takes only a few minutes. You will need your driver's license or social security number. Knowing this, will you now register to vote?" = "NUDGE"),
                         selected = "TRUST"),
             
             radioButtons("radio", label = h3("Select your colors"),
                          choices = list("Party" = "PARTY", "Sex" = "SEX", "School" = "CAMPUS"), 
                          selected = "PARTY"),
           ),
           mainPanel(
             plotOutput("plot1")
           )),
  # 2
  tabPanel("Questions Encoding",
           DT::DTOutput("q_enc_df")),
  
  
  # 3
  tabPanel("Crosstab Pivot Table",
           tabPanel("Pivot table with N/A values", rpivotTableOutput("OverallPivot"))),
  
  # 4
  tabPanel("Maps",
           navlistPanel(
             tabPanel("Voter Map", leafletOutput("voterMap")),
             tabPanel("Campus Map", leafletOutput("campusMap"))))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # output$plot1 <- renderPlot({
  #   ggplot(data= consentData1, aes(get(input$select), fill = get(input$radio)))+
  #     geom_bar(
  #       stat = "count",
  #       aes(y=..count..),)+
  #     scale_fill_manual(name = input$radio,
  #                       values = get(input$radio))}+
  #     coord_flip()+
  #     xlab(input$select)
  # )
  
  output$q_enc_df <- renderDT({
    questions_map_df = data.frame("question" = raw_questions,
                                  "question_code" = questions_map)
    
    questions_map_df$type = c("POSIXct",
                              sapply(questions_map_df[,setdiff(colnames(questions_map_df), c("time"))], class))
    
    DT::datatable(questions_map_df)
  })
  
  
  
  output$OverallPivot <- renderRpivotTable({
    rpivotTable(data = pivotData, cols = "O1", rows = c("D1", "D2"))
  })
  
  
  # output$voterMap <- renderLeaflet({
  #   leaflet() %>%
  #     addProviderTiles("Esri.WorldGrayCanvas") %>% 
  #     fitBounds(bbox[1],bbox[2],bbox[3],bbox[4]) %>%
  #     addCircles(data = pa.home.data, 
  #                weight = 2.5,
  #                color = ~party.pal(PARTY))
  # })
  
  # output$campusMap <- renderLeaflet({
  #   leaflet(pa.school.data) %>%
  #     addProviderTiles("Esri.WorldGrayCanvas") %>%
  #     addAwesomeMarkers(clusterOptions = markerClusterOptions(),
  #                       icon = icons,
  #                       label = labels)
  # })
  
}

# Run the application 
shinyApp(ui = ui, server = server)