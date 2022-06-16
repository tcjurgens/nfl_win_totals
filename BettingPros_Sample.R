library(tidyverse)
library(nflfastr)
library(glue)

pbp <- load_pbp(1999:2021)

games <- pbp %>% 
  select(game_id, season, week, home_team, away_team, posteam, defteam, play_type, epa, home_score, away_score, total, result)

load_sharpe_data <- function(file_name) {
  url <- glue("https://raw.githubusercontent.com/nflverse/nfldata/master/data/{file_name}.csv")
  suppressWarnings({ df <- read_csv(url, col_types = cols()) })
  return(df)
}

past_games <- load_sharpe_data("games") %>% filter(season %in% c(1999:2021)) %>%
  select(game_id, game_type, week, home_team, away_team, home_score, away_score, result, spread_line)

#filter so favored home teams spread_line column will now be negative
for(row in 1:nrow(past_games)) {
  past_games[row,'spread_line'] <- (past_games[row,'spread_line'])*-1
}
#result column will be negative if the home team wins outright
for(row in 1:nrow(past_games)) {
  past_games[row,'result'] <- (past_games[row,'result'])*-1
}

past_games <- past_games %>% mutate(
  home_win = case_when(result < 0 ~ 1),
  away_win = case_when(result > 0 ~ 1),
  tie = case_when(result == 0 ~ 1)
)

past_games <- past_games %>% filter(game_type == 'REG')
past_games[is.na(past_games)] <- 0

write.csv(past_games,'/Users/tcjurgens/Documents/BettingPros/data/past_games.csv')
