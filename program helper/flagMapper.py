def flagsMapper(filename):
	f = open(filename, "r")
	paragraph = ""
	for line in f:
		if line == "\n":
			process(paragraph)
			paragraph = ""
		else:
			paragraph += line

def process(paragraph):
	paragraph = paragraph.split("\n")
	(name, value) = getTitle(paragraph[0])
	descriptions = getDescriptions(paragraph[1:])
	jsonPrinter(name, descriptions[:-1], value)

def getTitle(line): # get flag name
	index = line.index("=")
	return (line[:index-1].lower(), line[index + 1:])

def getDescriptions(desc_array): # process descriptions
	descriptions = ""
	for setence in desc_array:
		descriptions += setence[1:]
		descriptions += " "
	return descriptions

def jsonPrinter(name, descriptions, value): # print out result in json format
	descriptions =  descriptions.replace('\"','')
	print("\"" + name + "\": {")
	print("  \"type\": \"boolean\",")
	print("  \"description\": " + "\"" + descriptions + "(aka " + value + ")" + "\"")
	print("},") 


# Test it
flagsMapper("/Users/tzhang1/Desktop/test.txt")