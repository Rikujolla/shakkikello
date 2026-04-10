/*
  Stockfish, a UCI chess playing engine derived from Glaurung 2.1
  Copyright (C) 2004-2008 Tord Romstad (Glaurung author)
  Copyright (C) 2008-2014 Marco Costalba, Joona Kiiski, Tord Romstad
  Main content of this file for Shakkikello made by Riku Lahtinen, 2025

  Stockfish is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Stockfish is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <iostream> // For cout debugging
#include <sstream>
#include <string>

#include "bitboard.h"
#include "evaluate.h"
#include "movegen.h"
#include "position.h"
#include "search.h"
#include "thread.h"
#include "tt.h"
#include "timeman.h"
#include "uci.h"

#include "sfos_uci.h"

using namespace std;

// FEN string of the initial position, normal chess
const char* StartFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

// Keep a track of the position keys along the setup moves (from the start position
// to the position just before the search starts). This is needed by the repetition
// draw detection code.
Search::StateStackPtr SetupStates;

/// SFOS Part 1
std::vector<std::string> g_siirrot; // SFOS
int g_depth;
int g_movetime;

// This function clears the game vectors
void SFOS::initio() {
//    cout << "initio alkaa" << endl;
    g_siirrot.clear();
    UCI::init(Options);
    Bitboards::init();
    Position::init();
    Bitbases::init();
    Search::init();
    Pawns::init();
    Eval::init();
    Threads.init();
    TT.resize(Options["Hash"]);

//    Threads.exit();

}

void SFOS::deletio() {
    Threads.exit();
//    cout << "Threadit pois" << endl;

}

void SFOS::inni() {
    string ransu;
    g_depth = myStoDepth.toInt();
    // Setting skill level for the move
    string g_skill = myStoSkill.toStdString();
    Options["Skill Level"] = g_skill;
    //cout << g_skill << " " << Options["Skill Level"] << endl;

    //Reducing stockfish time from nominal time to help app not freezing
    g_movetime = myStoMovetime.toInt() * 1000 - 130;
    //cout << g_depth << " " << g_movetime << " " << g_skill << endl;
    ransu=myTest.toStdString();//    Move m;
    g_siirrot.push_back(ransu);
    /*for (int ii = 0; ii < g_siirrot.size(); ii++) {
        cout << g_siirrot[ii] << " inni" << ii << endl;
    }*/

    loopi(g_siirrot);
}

// This function only adds a move to the vector, used to initialize the game for example with openings
void SFOS::innio() {
    g_siirrot.push_back(myTest.toStdString());
        /*for (int ii = 0; ii < g_siirrot.size(); ii++) {
            cout << g_siirrot[ii] << " innio" << ii << endl;
        }*/
}

// This function returns the move from Stockfish to Fastchess
void SFOS::outti() {
    extern std::string g_koruksi;
    //sync_cout << g_koruksi <<sync_endl;
    myTest = QString::fromStdString(g_koruksi);
    g_siirrot.push_back(g_koruksi);
//    for (int ii = 0; ii < g_siirrot.size(); ii++) {
//        cout << g_siirrot[ii] << " i" << ii << endl;
//    }
}

void loopi(const std::vector<std::string> &fransu) {
    Position pos(StartFEN, false, Threads.main()); // The root position
    Move m;
    string token, fen;
    fen=StartFEN;
    pos.set(fen, Options["UCI_Chess960"], Threads.main());
    SetupStates = Search::StateStackPtr(new std::stack<StateInfo>());
    int ind = 0;
    int koko;
    koko= fransu.size();
    //cout << "loopi" << koko << endl;
    while (ind < koko) {
        token = fransu[ind];
        // cout << "token" << token; //Konsoliin
        m = UCI::to_move(pos, token);
        SetupStates->push(StateInfo());

        pos.do_move(m, SetupStates->top(), pos.gives_check(m, CheckInfo(pos)));

        ind++;
    }
    Search::LimitsType limits;
    //limits.depth = g_depth; // Has to be parametrisized
    limits.movetime = g_movetime; //
    //cout << "Limits. movetime " << limits.movetime << endl;
    Threads.start_thinking(pos, limits, SetupStates);
}

