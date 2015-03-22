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
	name = getTitle(paragraph[0])
	descriptions = getDescriptions(paragraph[1:])
	jsonPrinter(name, descriptions)

def getTitle(line): # get flag name
	index = line.index("=")
	return line[:index-1].lower() 

def getDescriptions(desc_array): # process descriptions
	descriptions = ""
	for setence in desc_array:
		descriptions += setence[1:]
		descriptions += " "
	return descriptions

def jsonPrinter(name, descriptions): # print out result in json format
	descriptions =  descriptions.replace('\"','')
	print("\"" + name+"\": {")
	print("  \"type\": \"boolean\",")
	print("  \"description\": " + "\"" + descriptions + "\"")
	print("},") 


# Test it
# flagsMapper("/Users/tzhang1/Desktop/test.txt")