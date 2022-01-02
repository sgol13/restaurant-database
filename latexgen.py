import os

text = ""

for _, _, files in os.walk("."):
    for name in files:
        if name.endswith(".sql"):
            file = open(name, "r", encoding="utf8")
            text += file.read()
            file.close()

start = 0

fragments = {}

while start < len(text):
    a = text.find("-->", start)
    if a == -1:
        break

    b = text.find("--#", a)
    type = text[a+3:b].strip()

    c = text.find("---", b)
    title = text[b+3:c].strip()

    d = text.find("\n", c)
    desc = text[c+3:d].strip()

    while d + 1 == text.find("---", d):
        d1 = text.find("\n", d+1)
        desc += "\\\\\\indent{}" + text[d+4:d1].strip()
        d = d1

    e = text.find("--<", d)
    code = text[d:e].strip()

    if type not in fragments:
        fragments[type] = {}

    if title not in fragments[type]:
        fragments[type][title] = (desc, code)
    else:
        (desc0, code0) = fragments[type][title]
        fragments[type][title] = (desc0 + " " + desc, code0 + "\n\n" + code)

    start = e

latex = ""

types = ["Tabele", "Procedury", "Widoki", "Funkcje"]

for type in fragments:
    if type not in types:
        print("ZŁY TYP", type)
        exit(1)

for type in types:
    if type not in fragments:
        fragments[type] = []

    latex += "\\section{" + type + "}\n"

    for title in fragments[type]:
        (desc, code) = fragments[type][title]
        latex += "\\subsection{" + title + "}\n"
        latex += desc + "\n"
        latex += "\\begin{minted}[frame=lines, linenos, breaklines]{sql}\n" + \
            code + "\n\\end{minted}\n"

print(latex)
file = open("baza_opis.tex", "w", encoding="utf8")
file.write(latex)
file.close()
