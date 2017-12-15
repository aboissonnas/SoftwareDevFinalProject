def getEnvironments(stats):
    print("enter 'stop' to stop inputting environments")
    e = raw_input("enter environment: ")
    while e.lower() != "stop":
        stats.append(e)
        e = raw_input("enter environment: ")

def getMonsterStats(stats):
    s = ["name", "description", "hit points", "armor class", "fortitude",
         "reflex", "will", "strength", "dexterity",
         "constitution", "intelligence", "wisdom", "charisma",
         "xp"]
    for labels in s:
        stats.append(raw_input("enter %s: " %labels))

def writeToFile(file_path, stats):
    stuff_to_write = ""
    txt_file = open(file_path, "a+")
    for data in stats:
        stuff_to_write += data+","
    txt_file.write(stuff_to_write+"\n")
    txt_file.close()

def orderFile(file_path):
    lines = []
    with open(file_path) as f:
        for line in f:
            lines.append(line)
    w_file = open(file_path, "w")
    lines.sort()
    for line in lines:
        w_file.write(line)
    w_file.close()

def reformat(file_path):
    lines = []
    with open(file_path) as f:
        for line in f:
            lines.append(line)
            
    last_line = len(lines)-1
    last_char = len(lines[last_line])-1
    if lines[last_line][last_char] != "\n":
        lines[last_line] = lines[last_line] + "\n"
        
    txt_file = open(file_path, "w")
    for line in lines:
        txt_file.write(line)
    txt_file.close()

file_path = "Monster.txt"
reformat(file_path)
orderFile(file_path)

while True:
    stats = []
    getMonsterStats(stats)
    getEnvironments(stats)
    writeToFile(file_path, stats)
    orderFile(file_path)
