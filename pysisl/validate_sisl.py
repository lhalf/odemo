import pysisl
import sys
import jsonschema
import json

try:
    schema = json.loads(sys.argv[1])
    sisl_to_validate = sys.argv[2]
    pysisl.loads(sisl_to_validate, schema)
    print("Passed schema validation")
except json.JSONDecodeError:
    print("Invalid JSON in schema")
    sys.exit(0)
except ValueError:
    print("Invalid SISL provided")
    sys.exit(0)
except pysisl.sisl_decoder.SislValidationError as e:
    print(e)
    sys.exit(0)
