    function saveSettings() {
        //console.log("Save Settings")
        var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

        db.transaction(
            function(tx) {
                // Create the table, if not existing
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

                // valkomax
                var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'valkomax');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [valkomax, 'valkomax'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'valkomax', '', '', '', valkomax ])}
                // mustamax
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'mustamax');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [mustamax, 'mustamax'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'mustamax', '', '', '', mustamax ])}
                // increment
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'increment');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [increment, 'increment'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'increment', '', '', '', increment ])}
                // countDirInt
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'countDirInt');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [countDirInt, 'countDirInt'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'countDirInt', '', '', '', countDirInt ])}
                // countDirDown
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'countDirDown');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [countDirDown, 'countDirDown'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'countDirDown', '', '', '', countDirDown ])}
                // isMyStart
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'isMyStart');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [isMyStart, 'isMyStart'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'isMyStart', '', '', '', isMyStart ])}
                // playMode
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'playMode');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [playMode, 'playMode'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'playMode', '', playMode, '', '' ])}
                // openingMode
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingMode');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [openingMode, 'openingMode'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'openingMode', '', '', '', openingMode ])}
                // openingECO
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingECO');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [openingECO, 'openingECO'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'openingECO', '', openingECO, '', '' ])}
                // openingGame
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingGame');
                if (rs.rows.length > 0 && openingGame != "") {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [openingGame, 'openingGame'])}
                else if (openingGame != "") {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'openingGame', '', openingGame, '', '' ])}
                // openingGameMoves
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingGameMoves');
                if (rs.rows.length > 0 && openingGameMoves != "") {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [openingGameMoves, 'openingGameMoves'])}
                else if (openingGameMoves != ""){tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'openingGameMoves', '', openingGameMoves, '', '' ])}
                // stockfishSkill
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishSkill');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [stockfishSkill, 'stockfishSkill'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'stockfishSkill', '', '', '', stockfishSkill ])}
                // stockfishMovetime
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishMovetime');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [stockfishMovetime, 'stockfishMovetime'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'stockfishMovetime', '', '', '', stockfishMovetime ])}
                // startPage
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'startPage');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [startPage, 'startPage'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'startPage', '', '', '', startPage ])}
                // startPageTxt
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'startPageTxt');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [startPageTxt, 'startPageTxt'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'startPageTxt', '', startPageTxt, '', '' ])}
                // portFixed
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'portFixed');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [portFixed, 'portFixed'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'portFixed', '', '', '', portFixed ])}
                // myPort
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'myPort');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [myPort, 'myPort'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'myPort', '', '', '', myPort ])}

            }
        )

    }

function loadSettings() {
    //console.log("Load Settings")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

            // valkomax
            var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'valkomax');
            if (rs.rows.length > 0) {valkomax = rs.rows.item(0).valint}
            else {}
            // mustamax
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'mustamax');
            if (rs.rows.length > 0) {mustamax = rs.rows.item(0).valint}
            else {}
            // increment
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'increment');
            if (rs.rows.length > 0) {increment = rs.rows.item(0).valint}
            else {}
            // countDirInt
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'countDirInt');
            if (rs.rows.length > 0) {countDirInt = rs.rows.item(0).valint}
            else {}
            // countDirInt
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'countDirDown');
            if (rs.rows.length > 0) {
                var temp = rs.rows.item(0).valint;
                if (temp == 1) {
                    countDirDown = true;
                }
                else {
                    countDirDown = false;
                }
            }
            // isMyStart
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'isMyStart');
            if (rs.rows.length > 0) {isMyStart = rs.rows.item(0).valint}
            else {}
            // playMode
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'playMode');
            if (rs.rows.length > 0) {playMode = rs.rows.item(0).valte}
            else {}
            // openingMode
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingMode');
            if (rs.rows.length > 0) {openingMode = rs.rows.item(0).valint}
            else {}
            // openingECO
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingECO');
            if (rs.rows.length > 0) {openingECO = rs.rows.item(0).valte}
            else {}
            // openingGame
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ? AND valte IS NOT NULL', 'openingGame');
            if (rs.rows.length > 0) {openingGame = rs.rows.item(0).valte}
            else {}
            // openingGameMoves
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ? AND valte IS NOT NULL' , 'openingGameMoves');
            if (rs.rows.length > 0) {openingGameMoves = rs.rows.item(0).valte}
            else {}
            // stockfishSkill
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishSkill');
            if (rs.rows.length > 0) {stockfishSkill = rs.rows.item(0).valint}
            else {}
            // stockfishMovetime
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishMovetime');
            if (rs.rows.length > 0) {stockfishMovetime = rs.rows.item(0).valint}
            else {}
            // startPage
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'startPage');
            if (rs.rows.length > 0) {startPage = rs.rows.item(0).valint}
            else {}
            // startPageTxt
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'startPageTxt');
            if (rs.rows.length > 0) {startPageTxt = rs.rows.item(0).valte}
            else {}
            // portFixed
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'portFixed');
            if (rs.rows.length > 0) {portFixed = rs.rows.item(0).valint}
            else {}
            // myPort
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'myPort');
            if (rs.rows.length > 0) {myPort = rs.rows.item(0).valint}
            else {}

        }

    )

}

function saveInstantSetting() {
    //console.log("Save a setting")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

            // oppIP
            var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'oppIP');
            if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [oppIP, 'oppIP'])}
            else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'oppIP', '', oppIP, '', '' ])}
            // oppPort
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'oppPort');
            if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [oppPort, 'oppPort'])}
            else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'oppPort', '', '', '', oppPort ])}
        }

    )

}

function loadInstantSetting() {
    //console.log("Load Settings")
    var db = LocalStorage.openDatabaseSync("ChessDB", "1.0", "Chess database", 1000000);

    db.transaction(
        function(tx) {
            // Create the table, if not existing
            tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

            // oppIP
            var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'oppIP');
            if (rs.rows.length > 0) {oppIP = rs.rows.item(0).valte}
            else {}
            // oppPort
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'oppPort');
            if (rs.rows.length > 0) {oppPort = rs.rows.item(0).valint}
            else {}
        }

    )

}
