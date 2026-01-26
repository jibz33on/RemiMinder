from google import genai
from google.genai import types

client = genai.Client(vertexai=True, project="stunning-ripsaw-480402-i4", location="us-central1")

response = client.models.generate_content(
    model="gemma-3-1b-it",
    contents="Summarize: patient has chest pain for 3 days",
)

print(response.text)
