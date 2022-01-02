import os

text = ""

for _, _, files in os.walk("."):
    for name in files:
        if name.endswith(".sql"):
            file = open(name, "r", encoding="utf8")
            text += file.read()

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

    e = text.find("--<", d)
    code = text[d:e].strip()

    if type not in fragments:
        fragments[type] = []

    fragments[type].append((title, desc, code))

    start = e

latex = ""

for type in fragments:
    latex += "\\section{" + type + "}\n"

    for title, desc, code in fragments[type]:
        latex += "\\subsection{" + title + "}\n"
        latex += desc + "\n"
        latex += "\\begin{minted}[frame=lines, linenos]{sql}\n" + \
            code + "\n\\end{minted}\n"

print(latex)
file = open("baza_opis.tex", "w", encoding="utf8")
file.write(latex)
file.close()
