library(tidyverse)
library(glue)
library(nflfastR)

load_sharpe_data <- function(file_name) {
  url <- glue("https://raw.githubusercontent.com/nflverse/nfldata/master/data/{file_name}.csv")
  suppressWarnings({ df <- read_csv(url, col_types = cols()) })
  return(df)
}
gambling_dataf<-load_sharpe_data("games") %>%
  select(game_id, season, week, game_type, home_coach, away_coach, home_team, away_team, home_qb_name, away_qb_name,
         home_score, away_score, spread_line, result, home_moneyline, away_moneyline,
         total_line, total, overtime, home_rest, away_rest, div_game,
         weekday, gametime) %>% 
  filter(game_type == 'REG')

lines_22 <- gambling_dataf %>% 
  select(season, week, home_team,away_team, spread_line) %>% filter(season == 2022)

lines <- lines_22
write.csv(lines,'/Users/tcjurgens/Documents/BettingPros/data/lines.csv')




