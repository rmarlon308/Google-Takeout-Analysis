import codecs
import re
import pandas as pd


NO_WORDS = ["a","and","no","y","the","en","ni","in", "la","tu","que","si","mas","de","los","las","te",
	"no","el","me","for","por","una","uno","como","un","con","to","donde","dont","otro","is","yo","you",
	"ti","my","con","mi","se","pa","of","es","mi","so","o","sin", "-","1","2","3","4","5","6","7","8","9",
	"10","11"]

all_words = []

sentences = []
dates = []
hours = []

def monthTransform(month):
	switcher = {
		"ene": 1,
		"feb": 2,
		"mar": 3,
		"abr": 4,
		"may": 5,
		"jun": 6,
		"jul": 7,
		"ago": 8,
		"sept": 9,
		"oct": 10,
		"nov": 11,
		"dic": 12
	}
	return switcher.get(month, "Invalid month")


def toList(sentence, date):

	date = MyDate(date)
	sentences.append(sentence)
	dates.append(date.toString())
	hours.append(date.hour)
	
	words = sentence.split(" ")

	for word in words:
		if str(word).lower() not in NO_WORDS:
			all_words.append(str(word).lower())

class MyDate:

	def __init__(self, date):
		date = date.split(' ')
		self.year = date[2]
		self.month = monthTransform(date[1][0:-1])
		self.day = date[0]
		self.hour = date[3]

	def toString(self):
		return "-".join(str(i) for i in [self.year, self.month, self.day])

def main():
	
	file = codecs.open('historial-de-busqueda.html', 'r').read()
	for item in re.findall('href=(.*?)ECT', file):
		search = re.findall('\">(.*)', item)[0]
		sentence = search.split("</a><br>")[0]
		date = search.split("</a><br>")[1]
		toList(sentence, date)
	
	df_words = pd.DataFrame(list(zip(all_words)), 
               columns =['words'])

	print(df_words.head())

	df_words.to_csv('words.csv', index = False)

	
	df_sentences = pd.DataFrame(list(zip(sentences, dates, hours)), columns = ['sentences', 'dates', 'hours'])

	print(df_sentences.head())

	df_sentences.to_csv('sentences.csv', index = False)
	

if __name__ == '__main__':
	main()

	