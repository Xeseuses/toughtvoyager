import re

test_text = "In my post [[The Failure of Modern Day Democracy]] I already have argued..."
pattern = r'\[\[\s*(.*?)\s*\]\]'

matches = re.findall(pattern, test_text)
print("Matches:", matches)

