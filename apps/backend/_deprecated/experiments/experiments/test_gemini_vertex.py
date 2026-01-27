from google import genai

# This automatically uses your gcloud ADC credentials
client = genai.Client(
    vertexai=True,
    project="stunning-ripsaw-480402-i4",
    location="us-west4",
)

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents="Summarize: patient has chest pain for 3 days",
)

print(response.text)
