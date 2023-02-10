#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams,games")"



#reading from the games.csv file.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
     #Checking if its not the Heading ROW.
     if [[ $YEAR -ne 'year' ]]
     then
             
          # GET the WINNER ID.
          WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

          # Check If Winner ID is NULL.
          if [[ -z $WINNER_ID ]]
          then
              # IF winner ID is NULL THEN INSERT Winner IN teams TABLE.
              echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"

              # GET the WINNER ID again (We need it as a foreign key in games table).
              WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
          fi
          
          #GET the OPPONENT_ID.
          OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

          # Check if the Opponent ID is NULL.
          if [[ -z $OPPONENT_ID ]]
          then
               #INSERT OPPONENT IN teams TABLE.
               echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"

                #GET the OPPONENT_ID again (we need it as a foreign key in games table).
                OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
          fi

          # Inserting  in Games table
          echo "$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)")"
          
     fi

done