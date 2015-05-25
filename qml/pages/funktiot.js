
// this function transforms grid notation to FEN-notation

function gridToFEN() {
    console.log(fromIndex, toIndex)
    hopo.test = "";
    switch (fromIndex%8) {
    case 0: feni.startFeni= "h"
        break;
    case 1: feni.startFeni= "g"
        break;
    case 2: feni.startFeni= "f"
        break;
    case 3: feni.startFeni= "e"
        break;
    case 4: feni.startFeni= "d"
        break;
    case 5: feni.startFeni= "c"
        break;
    case 6: feni.startFeni= "b"
        break;
    case 7: feni.startFeni= "a"
        break;

    default: feni.startFeni = "m"
    }
    feni.stopFeni = (fromIndex-fromIndex%8)/8 +1;
    hopo.test = feni.startFeni+feni.stopFeni;

    switch (toIndex%8) {
    case 0: feni.startFeni= "h"
        break;
    case 1: feni.startFeni= "g"
        break;
    case 2: feni.startFeni= "f"
        break;
    case 3: feni.startFeni= "e"
        break;
    case 4: feni.startFeni= "d"
        break;
    case 5: feni.startFeni= "c"
        break;
    case 6: feni.startFeni= "b"
        break;
    case 7: feni.startFeni= "a"
        break;

    default: feni.startFeni = "m"
    }
    feni.stopFeni = (toIndex-toIndex%8)/8 +1;
    hopo.test = hopo.test+feni.startFeni+feni.stopFeni;

    console.log(hopo.test);

}

// this function transforms grid notation to FEN-notation

function fenToGRID() {
    console.log("FEN d2d4")


}
