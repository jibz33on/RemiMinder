from fastapi import FastAPI
from route import invitations, patient_register, caregiver_patient, caregivers
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# route for caregiver invitation
app.include_router(invitations.router)
# route for patient registration
app.include_router(patient_register.router)
# route to display caregiver_patient linking
app.include_router(caregiver_patient.router)
#route to register caregiver (w/o invitation)
app.include_router(caregivers.router)

@app.get("/")
def root():
    return {"message": "Backend running!"}