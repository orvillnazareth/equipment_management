# Load packages
library(shiny)
library(dplyr)
library(shinyjs)
library(googlesheets4)
library(shinymanager)

inactivity <- "function idleTimer() {
var t = setTimeout(logout, 120000);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions

function logout() {
window.close();  //close the window
}

function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, 120000);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();"

# Authenticate with Google Sheets
options(gargle_oauth_cache = "your-email@gmail.com")  # Replace with your email
gs4_auth(email = "your-email@gmail.com")  # Replace with your email

loginsheet <- read_sheet("link-to-your-google-sheet-with-login-information")
credentials <- loginsheet[,c(1,2)]
equipment_sheet <- read_sheet("link-to-your-google-sheet-with-login-information", col_types = "c")

ui <- secure_app(head_auth = tags$script(inactivity), fixedPage(
  useShinyjs(),
  navbarPage("Equipment management", position = "static-top",
             tabPanel("Equipment Selection",
                      h3("Equipment Details"),
                      DT::dataTableOutput("equipment_df"),
                      actionButton("add_row", "Select Equipment"),
                      hr(),
                      
                      h3("Transaction Log"),
                      DT::dataTableOutput("transaction_log"),
                      actionButton("delete_row", "Delete Entry")
             ),
             tabPanel("Verification",
                      sidebarLayout(
                        sidebarPanel(width = 4,
                                     h4("Your Name"),
                                     textOutput("user_name"),
                                     hr(),
                                     textInput("verifier_name", "Verifier Name"),
                                     passwordInput("verifier_pin", "Verifier Password"),
                                     textInput("noverify",HTML("Unable to instantly verify?<br/>add you own credentials above and add a nominee in the box below:")),
                                     textInput("update","Would you like to add an update?"),
                                     textInput("comment","Additional comments"),
                                     actionButton("submit", "Verify and Submit")
                        ),
                        mainPanel(
                          h3("Verification Log"),
                          DT::dataTableOutput("verification_log"),
                          actionButton("delete_row2", "Delete Selected Row")
                        )
                      )
             ),
             tabPanel("Register user", fluid = T,
                      sidebarLayout(
                        sidebarPanel(
                          textInput("name","Name"),
                          textInput("designation","Designation"),
                          textInput("contact_no","Contact Number"),
                          textInput("username","Username"),
                          textInput("password","Password"),
                          actionButton("submit_register","Register")
                        ),mainPanel()
                      ))
  ),
  tags$script(HTML("
                 setInterval(function(){
                 var currentTime = new Date();
                 varformattedTime = currentTime.toLocaleString();
                 Shiny.onInputChange('jsTime', formattedTime);
                 }, 1000);
                 "))
))

server <- function(input, output, session) {
  result_auth <- secure_server(check_credentials = check_credentials(credentials))
  options(gargle_oauth_cache = "your-email@gmail.com")  # Replace with your email
  gs4_auth(email = "wcsimumbai@gmail.com")  # Replace with your email
  name <- reactive({loginsheet %>% dplyr::filter(user == reactiveValuesToList(result_auth)[[1]]) %>% .$name})
  
  output$equipment_df <- DT::renderDataTable(equipment_sheet)
  
  data_table <- reactiveVal(data.frame())
  
  observeEvent(input$add_row, {
    selected_rows <- input$equipment_df_rows_selected
    if (length(selected_rows) > 0) {
      selected_data <- equipment_sheet[selected_rows, , drop = FALSE]
      updated_data <- rbind(data_table(), selected_data) %>% distinct()
      data_table(updated_data)
    }
  })
  
  observeEvent(input$delete_row, {
    t = data_table()
    if (!is.null(input$transaction_log_rows_selected)) {
      t <- t[-as.numeric(input$transaction_log_rows_selected),]
    }
    data_table(t)
  })
  
  output$transaction_log <- DT::renderDataTable({
    data_table()
  })
  
  output$user_name <- renderText(name())
  
  output$verification_log <- DT::renderDataTable({
    data_table()
  })
  
  observeEvent(input$delete_row2, {
    t = data_table()
    if (!is.null(input$verification_log_rows_selected)) {
      t <- t[-as.numeric(input$verification_log_rows_selected),]
    }
    data_table(t)
  })
  
  observeEvent(input$submit, {
    verifier_name <- input$verifier_name
    verifier_pin <- input$verifier_pin
    valid_verifier <- credentials %>%
      filter(user == verifier_name & password == verifier_pin)
    
    if (nrow(valid_verifier) == 1) {
      showModal(modalDialog(
        title = "Submission Successful",
        "Your entry has been successfully submitted. You are required to logout now. Login again to add a new submission.",
        easyClose = FALSE,
        footer = actionButton("reset", "Logout")
      ))
      submit_table <- cbind(data_table(),
                            user_name = name(),
                            verifier_name = verifier_name,
                            datetime = Sys.time()+19800,
                            update = input$update,
                            comment = input$comment,
                            nominee = input$noverify)
      submit_table %>% sheet_append("link-to-your-google-sheet-for-submissions", .)
      
    } else {
      showModal(modalDialog(
        title = "Verification Failed",
        "The verifier name or pin is incorrect.",
        easyClose = TRUE
      ))
    }
  })
  
  new_register_row <- reactive(data.frame(user = input$username,
                                          password = input$password,
                                          name = input$name,
                                          designation = input$designation,
                                          refered = reactiveValuesToList(result_auth)[[1]]))
  observeEvent(input$submit_register,{
    req(input$username)
    if (any(loginsheet$user == input$username)) {showModal(modalDialog("Username already exists. Kindly change username or contact support for help."))
      reset("password")}
    else {new_register_row() %>% sheet_append("link-to-your-google-sheet-with-login-information",.)
      showModal(modalDialog("Registeration complete"))
      reset("password")}
  })
  
  observeEvent(input$reset, {
    shinyjs::runjs("location.reload();")
  })
}

shinyApp(ui = ui, server = server)

# Copyright (c) 2024 orvillnazareth
#
# This source code is licensed under the MIT License found in the
# LICENSE file in the root directory of this source tree.
