#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPP WGOALS OGOALS
do
  if [[ $WINNER != 'winner' ]]
  then
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   if [[ -z $TEAM_ID ]]
   then 
    INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
   fi
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
 if [[ $OPP != 'opponent' ]]
  then
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
   if [[ -z $TEAM_ID ]]
   then 
    INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
   fi
   TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
  fi
 if [[ $YEAR != 'year' ]] 
 then
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
 OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
 INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPP_ID', '$WGOALS','$OGOALS')")
 fi
done
