#installing rVest packaage
install.packages("rvest")
# install.packages("XML")
library(rvest)
html_code = read_html("http://www.example.com/")

# selects one
# %>% is like a pipe it says we are still referring to the same data in the next line
html_code %>%
html_node("p") %>%
html_text()

#node finds one nodes finds all

#selects all
#html_form() %>%
html_code <- read_html("http://www.example.com/")
# %>% is like a pipe it says we are still referring to the same data in the next line
html_code %>%
html_nodes("p") %>%
html_text()

#selects table
html_code <- read_html("https://finance.yahoo.com/quote/%5EDJI?p=^DJI&.tsrc=fin-srch")
# %>% is like a pipe it says we are still referring to the same data in the next line
html_code %>%
html_nodes("table") %>%
html_text()

#second way
html_table(read_html("https://finance.yahoo.com/quote/%5EDJI?p=^DJI&.tsrc=fin-srch"))

# ***************reads forms

# reads table with get_nodes() function
url <- "https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwiAquTZ8IzsAhUOrJ4KHaesD7EQPAgI"


html_code <- read_html(url)
# %>% is like a pipe it says we are still referring to the same data in the next line
html_code %>%
html_nodes("input") %>%
html_text()

#better cleaner way
html_form(read_html(url))
