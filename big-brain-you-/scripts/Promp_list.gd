extends Node

var short_words = []
var medium_words = []
var long_words = []
var all_words = []

var text = """Vladimir Ilyich came to St. Petersburg in the autumn of 1893, but I did not get to know him until some time later. Comrades told me that a very erudite Marxist had arrived from the Volga. Afterwards I was given a pretty well-thumbed copy-book "On Markets" to read. The manuscript set forth the views of technologist Herman Krasin, our St. Petersburg Marxist, on the one hand, and those of the newcomer from the Volga on the other. The copy-book was folded down the middle, and on one side H. B. Krasin had set forth his views in a scrawly hand with many crossings out and insertions, while on the other side the newcomer had written his own remarks and objections in a neat hand without any alterations. The question of markets interested all of us young Marxists very much at the time. A definite trend had begun to crystallize among St. Petersburg Marxist study-circles at that time. The gist of it was this: the processes of social development appeared to the representatives of this trend as something mechanical and schematic. Such an interpretation of social development dismissed completely the role of the masses, the role of the proletariat. Marxism was stripped of its revolutionary dialectics, and only the bare "phases of development" remained. Today, of course, any Marxist would be able to refute that mechanistic conception, but at that time it was a cause of grave concern to our St. Petersburg Marxist circles. We were still poorly grounded theoretically and all that many of us knew of Marx was the first volume of Capital; as for The Communist Manifesto, we had never even set eyes on it. So it was more by instinct than anything else that we felt this mechanistic view to be the direct opposite of real Marxism. The question of markets had a close bearing on the general question of the understanding of Marxism. Exponents of the mechanistic view usually approached the question in a very abstract way. Since then more than thirty years have passed. Unfortunately, the copy-book has not survived, and I can only speak about the impression which it made on us. The question of markets was treated with ultra-concreteness by our new Marxist friend. He linked it up with the interests of the masses, and in his whole approach once sensed just that live Marxism which takes phenomena in their concrete surroundings and in their development. One wanted to make the closer acquaintance of this newcomer, to learn his views at first hand. I did not meet Vladimir Ilyich until Shrovetide. It was decided to arrange a conference between certain St. Petersburg Marxists and the man from the Volga at the flat of engineer Klasson, a prominent St. Petersburg Marxist with whom I had attended the same study-circle two years before. The conference was disguised as a pancake party. Besides Vladimir Ilyich, there were Klasson, Y. P. Korobko, Serebrovsky, S. I. Radchenko and others. Potresov and Struve were to have been there, too, but I don't think they turned up. I particularly remember one moment. The question came up as to what ways we should take. Somehow general agreement was lacking. Someone (I believe It was Shevlyagin) said that work on the Illiteracy Committee was of great importance Vladimir Ilyich laughed, and his laughter sounded rather harsh (I never heard him laugh that way again). "Well, if anyone wants to save the country by working In the Illiteracy Committee," he said, "let him go ahead." It should be said that our generation had witnessed in its youth the fight between the Narodovoltsi and tsarism. We had seen how the liberals, at first "sympathetic" about everything, had been scared into sticking their tail between their legs after the suppression of the Narodnaya Volya Party, and had begun to preach the doing of "little things." Lenin's sarcastic remark was quite understandable. He had come to discuss ways of fighting together, and had had to listen instead to an appeal for the distribution or the Illiteracy Committee's pamphlets. Later, when we got to know each other better, Vladimir Ilyich told me one day how this liberal "society" had reacted to the arrest of his elder brother Alexander Ulyanov. All acquaintances had shunned the Ulyanov family, and even an old teacher, who until then had come almost every evening to play chess, had left off calling. Simbirsk had no railway at the time, and Vladimir Ilyich's mother had had to travel to Syzran by horse-drawn vehicle in order to catch the train to St. Petersburg, where her son was imprisoned. Vladimir Ilyich was sent to find a way companion for her, but no one wanted to be seen with the mother of an arrested man. This general cowardice, Vladimir Ilyich told me, had shocked him profoundly at the time."""

func _ready():
	#var text = get_text_from_source()
	var cleaned = normalize_text(text)
	var words = split_to_words(cleaned)
	classify_by_length(words)
	all_words = short_words + medium_words + long_words 

func get_text_from_source():
	#var file_path = "res://mtext.txt"
	#var f = FileAccess.open(file_path, FileAccess.READ)
	#if f:
	#	return f.get_as_text()
	#return ""
	pass

func normalize_text(text: String) -> String:
	text = text.to_lower()
	var regex = RegEx.create_from_string("[^a-zåäö]")
	return regex.sub(text, " ", true)

func split_to_words(text: String) -> Array:
	var words = text.split(" ", false)
	var result = []
	
	for w in words:
		if w != "":
			result.append(w)
	
	return result

func classify_by_length(words: Array):
	short_words.clear()
	medium_words.clear()
	long_words.clear()
	
	for word in words:
		if word.length() <= 6:
			short_words.append(word)
		elif word.length() <= 7:
			medium_words.append(word)
		else:
			long_words.append(word)


func get_prompt() -> String: 
	var word_index = randi() % short_words.size()
	
	var word = short_words[word_index]
	
	return word
	
