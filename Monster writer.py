def validInputEntered(stats, messege):
    last_element = len(stats) - 1
    while stats[last_element] == "":
        print("Please enter valid input")
        stats[last_element] = raw_input(messege)

def validInputEnteredAt(stats, messege, index):
    last_element = index
    while stats[last_element] == "":
        print("Please enter valid input")
        stats[last_element] = raw_input(messege)

def getEnvironments(stats):
    print("enter 'stop' to stop inputting environments")
    e = raw_input("enter environment: ")
    while e.lower() != "stop":
        stats.append(e)
        validInputEntered(stats, "enter environment: ")
        e = raw_input("enter environment: ")

def getMonsterStats(stats):
    s = ["name", "description", "hit points", "armor class", "fortitude",
         "reflex", "will", "strength", "dexterity",
         "constitution", "intelligence", "wisdom", "charisma",
         "xp"]
    for labels in s:
        stats.append(raw_input("enter %s: " %labels))
        validInputEntered(stats, "enter %s: " %labels)

def checkInput(stats):
    s = ["name", "description", "hit points", "armor class", "fortitude",
         "reflex", "will", "strength", "dexterity",
         "constitution", "intelligence", "wisdom", "charisma",
         "xp"]
    print("\nAre these the correct input? Y/N")
    index = 0
    for i in range(len(s)):
        print(s[i] + " : " + stats[i])
        index += 1
    start_envir = index
    end_envir = index + (len(stats)-index)
    for i in range(start_envir, end_envir):
        print("environment : "+stats[i])
    return raw_input()


def makeCorrectionsToInput(stats):
    s = ["name", "description", "hit points", "armor class", "fortitude",
         "reflex", "will", "strength", "dexterity",
         "constitution", "intelligence", "wisdom", "charisma",
         "xp"]
    pick_again = "y"
    while pick_again == "y":
        print("which input do you want to fix?")
        
        for i in range(len(stats)):
            if i < len(s):
                print(str(i) + " (" + s[i] + " : " + stats[i] + ")")
            else:
                print(str(i) + " (environment : " + stats[i] + ")")
        print(str(len(stats)) + " - exit")
        
        choice = raw_input()
        
        while int(choice) < 0:
            print("please enter a valid option")
            choice = raw_input()
            
        if int(choice) >= len(stats):
            return
        else:
            message = ""
            if int(choice) < len(s):
                message = "enter %s: " % s[int(choice)]
                stats[int(choice)] = raw_input(message)
                validInputEnteredAt(stats, message, int(choice))
            else:
                message = "enter environment: "
                stats[int(choice)] = raw_input(message)
                validInputEnteredAt(stats, message, int(choice))
        
        pick_again = raw_input("want to change another stat? Y/N: ").lower()


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
    if checkInput(stats).lower() == "y":
        print("adding monster to file")
    else:
        print("please change the input")
        makeCorrectionsToInput(stats)

    writeToFile(file_path, stats)
    orderFile(file_path)
