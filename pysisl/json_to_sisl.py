import json
import pysisl
import sys

try:
    parsed_json = json.loads(sys.argv[1])
    print(pysisl.dumps(parsed_json))
        
except json.JSONDecodeError:
    print("{}")
