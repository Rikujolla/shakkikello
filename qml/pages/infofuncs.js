    function populateView() {
        //console.log("populating")
        var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

        db.transaction(
            function(tx) {
                // Create the table, if not existing
                tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');

                // Show all
                var rs = tx.executeSql('SELECT * FROM Recentmoves');

                // Filling the tag pairs table
                for(var i = 0; i < 7; i++) {
                    vars.tagpairs += rs.rows.item(i).stockwhite + ": " + rs.rows.item(i).stockblack + "\n";
                }

                // Filling movetext
                for(i = 7; i < rs.rows.length; i++) {
                    vars.moves += (i-6) + ". " + rs.rows.item(i).stockwhite + ", " + rs.rows.item(i).stockblack + "\n";
                }
            }
        )

    }

