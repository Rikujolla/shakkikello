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
public:
    explicit A(QObject *parent = 0) : QObject(parent){}
    QString reksi;

  QString test(){return myTest;}

  void setTest(QString teeu){
    myTest = teeu;
    testChanged(myTest);
  }
  Q_INVOKABLE  void inni();
  Q_INVOKABLE  void outti();

signals:
  void testChanged(QString teeu);

private:
  QString myTest;
};

class Veca : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList vtest READ vtest WRITE vsetTest NOTIFY vtestChanged)
public:
    explicit Veca(QObject *parent = 0) : QObject(parent){}


  QVariantList vtest(){return vmyTest;}

  void vsetTest(QVariantList vteeu){
    vmyTest = vteeu;
    vtestChanged(vmyTest);
  }

signals:
  void vtestChanged(QVariantList vteeu);

private:
  QVariantList vmyTest;
};
#endif // UCI_H
