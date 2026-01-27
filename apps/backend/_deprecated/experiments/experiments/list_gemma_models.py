from google import genai

client = genai.Client(
    vertexai=True,
    project="stunning-ripsaw-480402-i4",
    location="us-west4",
)

print("Listing Gemma models available to this project:\n")

for m in client.models.list():
    name = m.name.lower()
    if "gemma" in name:
        print(m.name)
