#! python3
# -*- coding: utf-8 -*-

from PyQt5.QtWidgets import *
from PyQt5.QtCore import QObject, pyqtSignal
from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(415, 141)
        #self.lineEdit = QtGui.QLineEdit(Dialog)
        self.lineEdit = QLineEdit(Dialog)
        self.lineEdit.setGeometry(QtCore.QRect(100, 40, 201, 31))
        self.lineEdit.setObjectName("lineEdit")
        self.pushButton = QPushButton(Dialog)
        self.pushButton.setEnabled(True)
        self.pushButton.setGeometry(QtCore.QRect(100, 80, 75, 23))
        self.pushButton.setAutoDefault(True)
        self.pushButton.setDefault(True)
        self.pushButton.setObjectName("pushButton")
        self.pushButton_2 = QPushButton(Dialog)
        self.pushButton_2.setGeometry(QtCore.QRect(230, 80, 75, 23))
        self.pushButton_2.setObjectName("pushButton_2")
        self.label = QLabel(Dialog)
        self.label.setGeometry(QtCore.QRect(130, 10, 151, 16))
        self.label.setMidLineWidth(0)
        self.label.setObjectName("label")

        self.retranslateUi(Dialog)
        #QtCore.QObject.connect(self.pushButton_2, SIGNAL("clicked()"), Dialog.close)
        self.pushButton_2.clicked.connect(Dialog.close)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle("Dialog")
        self.pushButton.setToolTip("Unlock the account you put after click Confirm")
        self.pushButton.setText("Confirm")
        self.pushButton_2.setText("Quit")
        self.label.setText( "Account to unlock")


if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    Dialog = QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()
    sys.exit(app.exec_())

