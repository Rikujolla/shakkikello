/*Copyright (c) 2015, Riku Lahtinen
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

#ifndef UCI_H
#define UCI_H

#include <QObject>
#include <QVariantList>
#include "notation.h"

class Position;

class A : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString test READ test WRITE setTest NOTIFY testChanged)
    Q_PROPERTY(QString stoDepth READ stoDepth WRITE setStoDepth NOTIFY stoDepthChanged)
    Q_PROPERTY(QString stoMovetime READ stoMovetime WRITE setStoMovetime NOTIFY stoMovetimeChanged)
    Q_PROPERTY(QString stoSkill READ stoSkill WRITE setStoSkill NOTIFY stoSkillChanged)
public:
    explicit A(QObject *parent = 0) : QObject(parent){}
    QString reksi;

  QString test(){return myTest;}
  QString stoDepth(){return myStoDepth;}
  QString stoMovetime(){return myStoMovetime;}
  QString stoSkill(){return myStoSkill;}

  void setTest(QString teeu){
    myTest = teeu;
    testChanged(myTest);
  }
  void setStoDepth(QString stode){
    myStoDepth = stode;
    stoDepthChanged(myStoDepth);
  }
  void setStoMovetime(QString stoti){
    myStoMovetime = stoti;
    stoMovetimeChanged(myStoMovetime);
  }
  void setStoSkill(QString stoski){
    myStoSkill = stoski;
    stoSkillChanged(myStoSkill);
  }
  Q_INVOKABLE  void initio();
  Q_INVOKABLE  void deletio();
  Q_INVOKABLE  void inni();
  Q_INVOKABLE  void innio();
  Q_INVOKABLE  void outti();

signals:
  void testChanged(QString teeu);
  void stoDepthChanged(QString stode);
  void stoMovetimeChanged(QString stoti);
  void stoSkillChanged(QString stoski);

private:
  QString myTest;
  QString myStoDepth;
  QString myStoMovetime;
  QString myStoSkill;
};

#endif // UCI_H
