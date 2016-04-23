/*Copyright (c) 2015-2016, Riku Lahtinen
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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

function populateGameInfoView(indxx) {
        console.log("populating sth new")
        var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

        db.transaction(
            function(tx) {
                // Create the table, if not existing
                tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS Gameinfo(gameid INTEGER, gamename TEXT, tagpairs TEXT, other TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS Moves(gameid INTEGER, moveid INTEGER, stockwhite TEXT, stockblack TEXT, addinfo TEXT, wtime TEXT, btime TEXT, other TEXT)');

                // Show all
                var rs = tx.executeSql('SELECT * FROM Gameinfo WHERE gameid=?', indxx);
                var rt = tx.executeSql('SELECT * FROM Moves WHERE gameid=?', indxx);
                var i
                // Filling the tag pairs table
                //for(var i = 0; i < 7; i++) {
                    vars.tagpairs = rs.rows.item(0).tagpairs;
                //}

                // Filling movetext
                for(i = 0; i < rt.rows.length; i++) {
                    vars.moves += (i+1) + ". " + rt.rows.item(i).stockwhite + ", " + rt.rows.item(i).stockblack + "\n";
                }
            }
        )

    }


function saveGameDB() {
    //console.log("Saving game to db")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the tables, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Gameinfo(gameid INTEGER, gamename TEXT, tagpairs TEXT, other TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Moves(gameid INTEGER, moveid INTEGER, stockwhite TEXT, stockblack TEXT, addinfo TEXT, wtime TEXT, btime TEXT, other TEXT)');

                    // Show all
                    var rs = tx.executeSql('SELECT * FROM Recentmoves');
                    var rt = tx.executeSql('SELECT * FROM Gameinfo');
                    var tagPairs = ""
                    var indX = rt.rows.length //Finding the index where to save the game
                    var move = ""

                    if (rs.rows.length >6) { //Testing that recent game has moves

                        //Filling the tag pairs table
                        for(var i = 0; i < 7; i++) {
                            tagPairs += rs.rows.item(i).stockwhite + ": " + rs.rows.item(i).stockblack + "\n";
                        }
                        tx.executeSql('INSERT INTO Gameinfo VALUES(?, ?, ?, ?)', [ indX, 'Noname ' + (indX + 1), tagPairs, 'something' ]);

                        // Filling movetext
                        for(i = 7; i < rs.rows.length; i++) {
                            tx.executeSql('INSERT INTO Moves VALUES(?, ?, ?, ?, ?, ?, ?, ?)', [ indX, i-6, rs.rows.item(i).stockwhite, rs.rows.item(i).stockblack, '', '', '', '' ]);
                        }
                    }
                }
                )

}

function deleteGame(indo) { //Filling the listView in GameList.qml
    console.log("delete Game", indo +1)
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the tables, if not existing
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Gameinfo(gameid INTEGER, gamename TEXT, tagpairs TEXT, other TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Moves(gameid INTEGER, moveid INTEGER, stockwhite TEXT, stockblack TEXT, addinfo TEXT, wtime TEXT, btime TEXT, other TEXT)');

                    // Show all
                    var rt = tx.executeSql('SELECT gameid FROM Gameinfo');
                    //console.log(rt.rows.item(indo).gameid, indo)
                    tx.executeSql('DELETE FROM Gameinfo WHERE gameid = ?', indo);
                    tx.executeSql('DELETE FROM Moves WHERE gameid = ?', indo);
                    for(var i = indo; i < (rt.rows.length -1); i++) {
                        var rs = tx.executeSql('SELECT gameid FROM Gameinfo WHERE gameid=?', i+1);
                        //console.log(i, i+1, rs.rows.item(0).gameid)
                        tx.executeSql('UPDATE Gameinfo SET gameid=? WHERE gameid=?', [i, i+1])
                        tx.executeSql('UPDATE Moves SET gameid=? WHERE gameid=?', [i, i+1])
                    }
                }
                )
    fillGameList()
}


function fillGameList() { //Filling the listView in GameList.qml
    //console.log("Filling game list")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the tables, if not existing
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS Recentmoves(stockwhite TEXT, stockblack TEXT, pgnwhite TEXT, pgnblack TEXT, comment TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Gameinfo(gameid INTEGER, gamename TEXT, tagpairs TEXT, other TEXT)');
                    //tx.executeSql('CREATE TABLE IF NOT EXISTS Moves(gameid INTEGER, moveid INTEGER, stockwhite TEXT, stockblack TEXT, addinfo TEXT, wtime TEXT, btime TEXT, other TEXT)');

                    // Show all
                    //var rs = tx.executeSql('SELECT * FROM Recentmoves');
                    var rt = tx.executeSql('SELECT * FROM Gameinfo');

                    //Filling the tag pairs table
                    listix.clear()
                    for(var i = 0; i < rt.rows.length; i++) {
                        listix.append({"iidee": rt.rows.item(i).gameid, "title": rt.rows.item(i).gamename})
                    }

                    //tx.executeSql('SELECT gameid FROM Gameinfo ORDER BY gameid DESC LIMIT 1,?', i+1)
                    //tx.executeSql('UPDATE
                }
                )

}


