/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** Modified for app Fast Chess 2016 by Riku Lahtinen
**
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

#ifndef SERVER_H
#define SERVER_H

//#include <QDialog>
#include <QObject>

class QLabel;
class QPushButton;
class QTcpServer;
class QNetworkSession;

class Server : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString smove READ smove WRITE setSmove NOTIFY smoveChanged) //own server move
    Q_PROPERTY(QString cipadd READ cipadd WRITE setCipadd NOTIFY cipaddChanged) // own device ip
    Q_PROPERTY(int cport READ cport WRITE setCport NOTIFY cportChanged) // own device port
    Q_PROPERTY(QString waitmove READ waitmove WRITE setWaitmove NOTIFY waitmoveChanged) // own device port

public:
    explicit Server();
    QString smove(){return mySmove;}
    void setSmove(QString see1){
      mySmove = see1;
      smoveChanged(mySmove);
    }
    QString cipadd(){return myCipadd;}
    void setCipadd(QString see2){
      myCipadd = see2;
      cipaddChanged(myCipadd);
    }
    int cport(){return myCport;}
    void setCport(int see3){
      myCport = see3;
      cportChanged(myCport);
    }
    QString waitmove(){return myWaitmove;}
    void setWaitmove(QString see4){
      myWaitmove = see4;
      waitmoveChanged(myWaitmove);
    }
    //Q_INVOKABLE void sessionOpened();

signals:
    void smoveChanged(QString see1);
    void cipaddChanged(QString see2);
    void cportChanged(int see3);
    void waitmoveChanged(QString see4);

private slots:
    void sessionOpened();
    void sendFortune();

private:
    QTcpServer *tcpServer;
    QNetworkSession *networkSession;
    QString mySmove;
    QString myCipadd;
    int myCport;
    QString myWaitmove;
};

#endif
