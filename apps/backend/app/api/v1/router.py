"""
API Router for version 1 endpoints
"""
from fastapi import APIRouter
from .endpoints import users, caregivers, caregiver_patient, invitations, patient_register, visit_summary, reminders, product_demo

# Create the main API router
api_router = APIRouter()

# Include all endpoint routers
api_router.include_router(users.router)
api_router.include_router(caregivers.router)
api_router.include_router(caregiver_patient.router)
api_router.include_router(invitations.router)
api_router.include_router(patient_register.router)
api_router.include_router(visit_summary.router)
api_router.include_router(reminders.router)
api_router.include_router(product_demo.router)
