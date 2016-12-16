#!/usr/bin/python

from Tkinter import *
import subprocess


main = Tk()
oldPW = StringVar(None)
newPW = StringVar(None)
confirmPW = StringVar(None)
flash_text = StringVar(None)

flash = Label(main, textvariable=flash_text, justify="right")
flash.grid(row=0, columnspan=2)

def changePW():
    if not newPW.get() == confirmPW.get():
	flash_text.set("Passwords do not match")
	flash.config(fg="red")
	return
    else:
	kpasswd = ""
	try:
	    kpasswd = subprocess.check_output('printf "%%s\n%%s\n%%s\n" "%s" "%s" "%s"  | kpasswd' %(oldPW.get(), newPW.get(), confirmPW.get()), shell=True)
	except subprocess.CalledProcessError, e:
	    flash.config(fg="red")
	    flash_text.set("Invalid Old Password")
	if "password changed" in kpasswd.lower():
	    flash.config(fg="green")
	    flash_text.set("Your password was changed")
	print kpasswd

old = Entry(main, width=25, textvariable=oldPW, show="*")
new1 = Entry(main, width=25, textvariable=newPW, show="*")
new2 = Entry(main, width=25, textvariable=confirmPW, show="*")

old_label_text = StringVar()
new1_label_text = StringVar()
new2_label_text = StringVar()

old_label_text.set("Current Password:")
new1_label_text.set("New Password:")
new2_label_text.set("Confirm New Password:")

old_label = Label(main, textvariable=old_label_text, justify="right")
old_label.grid(row=1, column=0, sticky="w")
old.grid(row=1, column=1)

new1_label = Label(main, textvariable=new1_label_text, justify="right")
new1_label.grid(row=2, column=0, sticky="w")
new1.grid(row=2, column=1)

new2_label = Label(main, textvariable=new2_label_text, justify="right")
new2_label.grid(row=3, column=0, sticky="w")
new2.grid(row=3, column=1)

change = Button(main, text="Change", command=changePW)
cancel = Button(main, text="Cancel", command=quit)
change.grid(row=4,column=0)
cancel.grid(row=4,column=1)
main.title("Change Your Password")
main.mainloop()
