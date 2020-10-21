library(dplyr)
starwars

# filter() picks cases based on their values
starwars %>% 
filter(species == "Droid")


# select() picks variables based on their name
starwars %>% 
  select(name, ends_with("color"))


# mutate() adds new variables that are functions of existing variables
starwars %>% 
  mutate(name, bmi = mass / ((height / 100)  ^ 2)) %>%
  select(name:mass, bmi)


# arrange() changes the ordering of the rows
starwars %>% 
  arrange(desc(mass))


# group_by() allows to perform any operation by a group
# summarise() reduces multiple alues down to a single summary
starwars %>%
  group_by(species) %>%
  summarise(n = n(),mass = mean(mass, na.rm = TRUE)) %>%
  filter(n > 1,mass > 50)





