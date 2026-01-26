from google import genai

client = genai.Client(
    vertexai=True,
    project="stunning-ripsaw-480402-i4",
    location="us-central1",
)

print("Listing models...\n")

for m in client.models.list():
    print(m.name)
