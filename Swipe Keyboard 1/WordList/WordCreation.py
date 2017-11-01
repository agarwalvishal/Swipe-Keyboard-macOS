
def filtering(word):


	word = word.rstrip()
	word = word.lower()
	
	for each in word:
		
		if ord(each) >= 97 and ord(each) <= 122:
			continue
		else:
			return ""

	return word


file_input = open('wlist_match9.txt','r')
count  = 0


currentFirstLetter = 'a'
currentLastLetter = 'a'

print(currentFirstLetter + currentLastLetter)
	
word = ''

try:
	
	while True :

		word = file_input.readline()

		word = filtering(word)

		if len(word) == 0:
			continue
		FirstLetter = word[0]
		LastLetter = word[-1]
		file_output = open(FirstLetter + LastLetter,'a')
		file_output.write(word+'\n')
		file_output.close()

		if not(currentFirstLetter == FirstLetter and currentLastLetter == LastLetter):
	
			currentFirstLetter = FirstLetter
			currentLastLetter = LastLetter
			print(currentFirstLetter + currentLastLetter)
	
		count += 1

except Exception as e:
	print(str(e) + 'No other words' + word)


finally:
	print 'Total count ' + str(count)
	file_input.close()
