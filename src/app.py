import base64
import copy
import http

import jsonpatch
from flask import Flask, jsonify, request

app = Flask(__name__)


def remove_cpu_requests(spec):
  for container in spec["spec"]["containers"]:
    if "resources" in container.keys():
      if "requests" in container["resources"].keys():
        if "cpu" in container["resources"]["requests"]:
          container["resources"]["requests"]["cpu"] = None
  return spec

@app.route("/mutate", methods=["POST"])
def mutate():
  spec = request.json["request"]["object"]

  try:
    modified_spec = remove_cpu_requests(spec = copy.deepcopy(spec))
  except KeyError:
    pass

  patch = jsonpatch.JsonPatch.from_diff(spec, modified_spec)
  return jsonify(
    {
      "apiVersion": "admission.k8s.io/v1",
      "kind": "AdmissionReview",
      "response": {
        "allowed": True,
        "uid": request.json["request"]["uid"],
        "patch": base64.b64encode(str(patch).encode()).decode(),
        "patchType": "JSONPatch",
      }
    }
  )


@app.route("/health", methods=["GET"])
def health():
  return ("", http.HTTPStatus.NO_CONTENT)


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
