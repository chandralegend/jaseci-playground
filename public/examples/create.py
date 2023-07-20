import json
import os

files = os.listdir('./')

examples = []

for file in files:
    if file.endswith(".jac"):
        examples.append({
            "name": file,
            "content": open(file, 'r').read(),
            "language": "jaseci",
        })

with open('examples.json', 'w') as outfile:
    json.dump(examples, outfile)
