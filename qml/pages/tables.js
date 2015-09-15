function clearRecent() {
    //console.log("Clearing recent moves")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');

            // Deleting all entries from recent moves
            tx.executeSql('DELETE FROM Recentmoves');

            // Adding comment row
            tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Event', 'Local Event', 'e', 'e', '[ssss]' ]);
            tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Site', 'Local Site', 'e', 'e', '[ssss]' ]);
            tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Date', startti.dateTag, 'e', 'e', '[ssss]' ]);
            tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Round', '1', 'e', 'e', '[ssss]' ]);
            tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'White', 'Me', 'e', 'e', '[ssss]' ]);
            if (playMode == "stockfish") {
                tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Black', 'Stockfish, v5', 'e', 'e', '[ssss]' ]);
            }
            else {
                tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Black', 'You', 'e', 'e', '[ssss]' ]);
            }

            tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ 'Result', '*', 'e', 'e', '[ssss]' ]);

        }
    )

}

function addMove() {
    //console.log("Adding recent moves")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');

            // Adding amove
            if (tilat.valko) {
                tx.executeSql('INSERT INTO Recentmoves VALUES(?, ?, ?, ?, ?)', [ hopo.test, ' ', 'e4', 'c5', '{comment}' ]);
            }
            else {
                tx.executeSql('UPDATE Recentmoves SET stockblack=? WHERE ROWID = last_insert_rowid()', [hopo.test]);
            }
        }
    )

}
