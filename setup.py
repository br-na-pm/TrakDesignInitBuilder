from cx_Freeze import setup, Executable

base = None

executables = [Executable("main.py", base=base)]

packages = ["idna", "tkinter", "generate", "os", "math", "xml.etree.ElementTree"]
options = {
    'build_exe': {
        'packages': packages,
    },
}

setup(
    name="<TrakDesignInitBuilder>",
    options=options,
    version="0.1.0",
    description='',
    executables=executables
)
