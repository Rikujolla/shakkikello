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
                // openingMode
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingMode');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [openingMode, 'openingMode'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'openingMode', '', '', '', openingMode ])}
                // openingECO
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingECO');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte=? WHERE name=?', [openingECO, 'openingECO'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'openingECO', '', openingECO, '', '' ])}
                // stockfishSkill
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishSkill');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [stockfishSkill, 'stockfishSkill'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'stockfishSkill', '', '', '', stockfishSkill ])}
                // stockfishMovetime
                rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishMovetime');
                if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valint=? WHERE name=?', [stockfishMovetime, 'stockfishMovetime'])}
                else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'stockfishMovetime', '', '', '', stockfishMovetime ])}


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
            // openingMode
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingMode');
            if (rs.rows.length > 0) {openingMode = rs.rows.item(0).valint}
            else {}
            // openingECO
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'openingECO');
            if (rs.rows.length > 0) {openingECO = rs.rows.item(0).valte}
            else {}
            // stockfishSkill
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishSkill');
            if (rs.rows.length > 0) {stockfishSkill = rs.rows.item(0).valint}
            else {}
            // stockfishMovetime
            rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'stockfishMovetime');
            if (rs.rows.length > 0) {stockfishMovetime = rs.rows.item(0).valint}
            else {}

        }

    )

}
