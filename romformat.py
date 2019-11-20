import re
import pprint
import collections

def dictreplace(text, wordDict):
    for key in wordDict:
        text = text.replace(key, wordDict[key])
    return text

# rom layout:
# commands
# variable defs
# labels
# dereferences (mem_loc_of)

varre = re.compile(r"[\*#]?(\w*)\s*=\s*('?\w*);(?:\s*\/\/\s*(.*))?")
comre = re.compile(r"(:\w+:)?\s*([_A-Z]+)\s+(&?\w+|:\w+:);(?:\s*\/\/\s*(.*))?")

# change this to the word width, not sure on the system verilog syntax
romformat = "{{`{command}, 7'd{addr}}};"
romformat_comment = romformat + " // {comment}"
varformat = "{val}; // {varname}"
lineerror = "Error in line [{}]: {}"

variables = collections.OrderedDict()

pointers = {}
defines = {}
comments = {}

commands = []
rom_out = []

with open("d2_3.4.txt") as rom:
    for lineno, line in enumerate(rom, 1):
        if line.startswith("//") or line.isspace():
            continue

        if "=" in line:  # assignment
            varmatch = varre.match(line)
            if (varmatch == None):
                print(lineerror.format(lineno, line))
                continue

            if varmatch.group(3):
                comments[varmatch.group(1)] = varmatch.group(3)

            if "*" in line:  # ptr
                pointers[varmatch.group(1)] = varmatch.group(2)
            elif "#" in line:
                defines[varmatch.group(1)] = varmatch.group(2)
            else:
                variables[varmatch.group(1)] = varmatch.group(2)
        else:
            match = comre.match(line)
            if match != None:
                commands.append(line.strip())
                if match.group(1):  # if there's a label here
                    variables[match.group(1)] = len(commands) - 1
            else:
                print(lineerror.format(lineno, line))

# replace defines
commands = [dictreplace(com, defines) for com in commands]

# replace variables with mem locations
for command in commands:
    match = comre.match(command)
    if (match == None):
        print("Error in replace mem loc")
        continue

    comment = match.group(3)
    if match.group(1):  # label
        comment += " - label: " + match.group(1)
    if match.group(4):
        comment += " - " + match.group(4)

    if "&" in match.group(3):
        if match.group(3)[1:] in variables:
            variables["mem_loc_of_" + match.group(3)[1:]] = list(
                variables.keys()).index(match.group(3)[1:]) + len(commands)
            address = list(variables.keys()).index(
                "mem_loc_of_" + match.group(3)[1:]) + len(commands)

            rom_out.append(romformat_comment.format(
                command=match.group(2), addr=address, comment=comment))
    elif match.group(3) in variables:
        address = list(variables.keys()).index(match.group(3)) + len(commands)

        rom_out.append(romformat_comment.format(
            command=match.group(2), addr=address, comment=comment))
    elif match.group(3) in pointers:
        rom_out.append(romformat_comment.format(command=match.group(
            2), addr=pointers[match.group(3)], comment=comment))

for var, val in variables.items():
    formattedstr = varformat.format(
        val=val, varname=var if (":" not in var) else var + " label")

    if var in comments:
        formattedstr += " - " + comments[var]

    rom_out.append(formattedstr)

for index, item in enumerate(rom_out):
    print("{index}: mdr = {command}".format(index=index, command=item))

# pprint.pprint(comments)
# pprint.pprint(variables)
# pprint.pprint(pointers)
# pprint.pprint(defines)
# pprint.pprint(commands)
# pprint.pprint(rom_out)
