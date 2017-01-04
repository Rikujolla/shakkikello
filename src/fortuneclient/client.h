/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Modified for app Fast Chess 2016 by Riku Lahtinen
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef CLIENT_H
#define CLIENT_H
#include <QObject>
#include <QTcpSocket>
#include <QDataStream>

class QTcpSocket;
class QNetworkSession;

class Client : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sipadd READ sipadd WRITE setSipadd NOTIFY sipaddChanged)
    Q_PROPERTY(int sport READ sport WRITE setSport NOTIFY sportChanged)
    Q_PROPERTY(QString cmove READ cmove WRITE setCmove NOTIFY cmoveChanged) //opponents move

public:
    explicit Client();
    QString sipadd(){return mySipadd;}
    void setSipadd(QString tee1){
      mySipadd = tee1;
      sipaddChanged(mySipadd);
    }
    int sport(){return mySport;}
    void setSport(int tee2){
      mySport = tee2;
      sportChanged(mySport);
    }
    QString cmove(){return myCmove;}
    void setCmove(QString tee3){
      myCmove = tee3;
      cmoveChanged(myCmove);
    }
    Q_INVOKABLE void requestNewFortune();
    Q_INVOKABLE void startClient();

signals:
    void sipaddChanged(QString tee1);
    void sportChanged(int tee2);
    void cmoveChanged(QString tee3);

private slots:
    //void requestNewFortune();
    void readFortune();
    void displayError(QAbstractSocket::SocketError socketError);
    void sessionOpened();

private:
    QTcpSocket *tcpSocket;
    QDataStream in;
    QString currentFortune;
    QNetworkSession *networkSession;
    QString mySipadd;
    int mySport;
    QString myCmove;
};

#endif
