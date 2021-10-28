import tkinter
from tkinter import *
from tkinter import filedialog as fd
from tkinter import messagebox
import generate

# define master
master = Tk()
master.title('TrakDesign Task HW Parser')
# master.iconbitmap('icon.ico')


def validate_num(numinput):
    if numinput.isdigit():
        # print(numinput)
        return True

    elif numinput == "":
        # print(numinput)
        return True

    else:
        # print(numinput)
        return False


# Define Labels
hwLabel = Label(master, text="Hardware File Path:").grid(row=0)
initLabel = Label(master, text="TrakDesign Init File Path:").grid(row=1)
psLabel = Label(master, text="How many segments per PS cable?").grid(row=2)
howToLabel = Label(master, text="Script is meant to be used with the init.st file formatted as "
                                "imported in the TrakDesign package. It looks for the comment at the "
                                "top of the segment section \n '// segment assembly.' It also requires that there are "
                                "some segments in the init, it will error if there are none.",
                   justify="left").grid(row=5, columnspan=5)

# Define Fields
hwPathField = Entry(master, width=100)
hwPathField.grid(row=0, column=1, columnspan=3, padx=10)
initPathField = Entry(master, width=100)
initPathField.grid(row=1, column=1, columnspan=3, padx=10)
psCountField = Entry(master, width=100)
psCountField.grid(row=2, column=1, columnspan=3, padx=10)
psCountField.insert(0, '5')

reg = master.register(validate_num)
psCountField.config(validate="key", validatecommand=(reg, '%P'))


def callback_hw():
    hw_fp = fd.askopenfilename()
    hwPathField.delete(0, END)
    hwPathField.insert(0, hw_fp)


def callback_init():
    init_fp = fd.askopenfilename()
    initPathField.delete(0, END)
    initPathField.insert(0, init_fp)


def callback_generate():
    hw_file_path = hwPathField.get()
    init_file_path = initPathField.get()
    num_cables = int(psCountField.get())
    if hw_file_path == '':
        response = messagebox.showwarning('Warning!', 'Please choose a hardware file path')
    elif init_file_path == '':
        response = messagebox.showwarning('Warning!', 'Please choose a init file path')
    else:
        generate.generate_func(init_file_path, hw_file_path, num_cables)
        response = messagebox.showinfo('Success!', 'Init file generation successful')
        if response == 'ok':
            master.destroy()


# Define buttons
Button(master, text='Open hardware File', command=callback_hw, width=20).grid(row=0, column=5, sticky=W, pady=4)
Button(master, text='Open Init File', command=callback_init, width=20).grid(row=1, column=5, sticky=W, pady=4)
Button(master, text='Generate!', command=callback_generate, width=20).grid(row=5, column=5, sticky=W, pady=4)

mainloop()
