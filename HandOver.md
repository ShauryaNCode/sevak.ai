# SevakAI Deployment, Handoff, and Submission Guide

## Overview

SevakAI is a disaster response coordination platform with two primary interfaces:

- `Volunteer App` — used by volunteers in the field to register, update their profile, report needs, receive assignments, and complete tasks
- `Admin Dashboard` — used by coordinators, district admins, and national admins to manage volunteers, camps, needs, and task assignments

Both interfaces connect to the same backend and share the same operational data.

---

## Submission Links

For final submission, the project should expose these 4 links:

- `MVP Link` — live admin dashboard frontend
- `Prototype Link` — detailed walkthrough/prototype page covering both main screens
- `Backend Docs Link` — live FastAPI Swagger docs
- `Backend Demo Link` — live backend demo page with reviewer controls

Recommended format:

- `MVP`: `https://your-admin-site.vercel.app`
- `Prototype`: `https://your-admin-site.vercel.app/prototype`
- `Backend Docs`: `https://your-api.onrender.com/docs`
- `Backend Demo`: `https://your-api.onrender.com/demo`

---

## Final Architecture

### Hosting Plan

- `Backend`: Render
- `Frontend (Admin Web)`: Vercel
- `Database`: Firestore
- `Mobile Volunteer App`: local demo / device demo / optional future distribution

### Why This Setup

- Render is suitable for the FastAPI backend
- Flutter web builds to static files, which can be hosted on Vercel
- Firestore provides persistent cloud storage for needs, camps, volunteers, and assignments
- This avoids relying on local JSON persistence, which is not suitable for production/demo hosting

---

## Team Split

The project can be split cleanly between two members.

### Member 1
Backend / Render / Firestore / Demo

### Member 2
Frontend / Vercel / Prototype / Submission presentation layer

---

# Member 1 Handoff Checklist
## Backend / Render / Demo Owner

### Responsibilities

- Deploy FastAPI backend to Render
- Configure Firestore
- Verify public backend endpoints
- Build and expose `/demo`
- Support frontend integration with the deployed API

### Checklist

- [ ] Confirm backend runs locally
- [ ] Confirm Firestore is used in production instead of local JSON fallback
- [ ] Confirm all required environment variables are documented
- [ ] Deploy backend to Render
- [ ] Set Render build command:
```bash
pip install -r requirements.txt
```
- [ ] Set Render start command:
```bash
uvicorn app.main:app --host 0.0.0.0 --port $PORT
```
- [ ] Configure CORS to allow the final Vercel frontend domain
- [ ] Verify public routes:
  - [ ] `/health`
  - [ ] `/docs`
  - [ ] `/debug/ai-triage`
  - [ ] `/demo`
- [ ] Build `/demo` page with reviewer buttons
- [ ] Prepare demo test accounts and phone numbers
- [ ] Confirm admin login works in production
- [ ] Confirm manually added volunteers can later log in on mobile using their number
- [ ] Confirm camp manager role elevation works after re-login
- [ ] Test full volunteer/camp/need lifecycle
- [ ] Share final Render API base URL with Member 2

### Suggested `/demo` Buttons

The `/demo` page should be a simple reviewer control panel with buttons for:

- `Seed Demo Data`
- `Create Mock Volunteer`
- `Create Mock Camp`
- `Create Mock Need`
- `Assign Volunteer to Need`
- `Mark Need Completed`
- `Run AI Triage Sample`
- `Reset Demo State`
- `Open Swagger Docs`
- `Open Health Check`

### Member 1 Deliverables

- [ ] Render API URL
- [ ] Backend Docs URL
- [ ] Backend Demo URL
- [ ] Firestore confirmed working
- [ ] Production env var list
- [ ] Demo reviewer accounts / numbers

### Required Environment Variables

Suggested minimum:

- `USE_FIRESTORE=true`
- `FIREBASE_PROJECT_ID=...`
- `FIREBASE_CREDENTIALS_PATH=...`
- `FIRESTORE_COLLECTION_NAME=sevakai_documents`
- `PUBLIC_BASE_URL=https://your-render-service.onrender.com`
- `CORS_ALLOW_ORIGINS=...`

Plus any already-used service variables such as AI or messaging credentials.

### Member 1 Verification Script

Before handoff, verify:

1. Open `/health`
2. Open `/docs`
3. Test `/debug/ai-triage` with a sample disaster message
4. Open `/demo`
5. Seed demo data
6. Confirm demo data appears in Firestore
7. Confirm frontend can read and write to the deployed backend

---

# Member 2 Handoff Checklist
## Frontend / Vercel / Prototype Owner

### Responsibilities

- Build and host Flutter web admin frontend
- Connect frontend to deployed backend
- Create the prototype page
- Prepare reviewer-facing submission experience

### Checklist

- [ ] Confirm frontend builds successfully against deployed backend
- [ ] Build Flutter web with production API URL
- [ ] Deploy built web output to Vercel
- [ ] Verify admin routes work
- [ ] Verify login and routing logic works
- [ ] Verify dashboard reads live backend data
- [ ] Verify volunteer management features work
- [ ] Verify camp management features work
- [ ] Verify need management features work
- [ ] Create `/prototype` page
- [ ] Add screenshots or polished screen captures
- [ ] Add reviewer walkthrough section
- [ ] Add links to MVP, backend docs, and backend demo
- [ ] Share final frontend URL with team

### Production Build Command

```bash
flutter build web -t lib/main.dart --dart-define=DEV_API_BASE_URL=https://YOUR-RENDER-URL/api/v1
```

### Key Web Routes to Verify

- `/coordinator/dashboard`
- `/coordinator/needs`
- `/coordinator/volunteers`
- `/coordinator/resources`
- `/coordinator/map`
- `/coordinator/settings`

### Member 2 Deliverables

- [ ] Vercel MVP URL
- [ ] Prototype URL
- [ ] Screenshot assets
- [ ] Reviewer walkthrough page
- [ ] Tested production frontend

### Member 2 Verification Script

1. Open deployed Vercel app
2. Login as admin
3. Open dashboard
4. View needs
5. View volunteers
6. View camps
7. Assign a volunteer to a need
8. Refresh the page and confirm state still behaves correctly
9. Confirm browser routing works as expected

---

# Integration Checklist

## Member 1 must provide to Member 2

- [ ] Final backend base URL
- [ ] Confirmed admin test phone number
- [ ] Sample volunteer phone number
- [ ] CORS confirmation
- [ ] Firestore confirmation
- [ ] Demo/reset instructions

## Member 2 must provide to Member 1

- [ ] Final frontend Vercel URL
- [ ] Final prototype URL
- [ ] Browser/API errors seen during deployment testing
- [ ] Final reviewer flow steps

---

# Prototype Plan

The prototype should be detailed and centered around the two main screens:

- `Volunteer App Screen`
- `Admin Dashboard Screen`

This should not be just a mockup. It should explain how the actual product works and guide reviewers through the system.

---

## Prototype Structure

Recommended sections:

1. Overview
2. Volunteer App Screen
3. Admin Dashboard Screen
4. Data Flow Between Both Screens
5. AI / Automation Support
6. Reviewer Walkthrough
7. Submission Links

---

## 1. Overview

SevakAI is a disaster response coordination platform designed for active emergency operations.

It has two main interfaces:

- a mobile volunteer-facing experience for field execution
- a web-based admin dashboard for command and coordination

Both interfaces are connected to the same backend and reflect shared operational state across volunteers, camps, needs, and assignments.

---

## 2. Volunteer App Screen

The volunteer app is the field operations interface.

### Main Capabilities

- Phone/OTP login
- Volunteer registration
- Profile update
- GPS-based location capture
- Manual location fallback
- Post new need
- View assigned mission
- Contact reporter
- Mark mission completed

### Detailed Volunteer Flow

- Volunteer logs in using phone number and OTP
- If the volunteer profile does not exist yet, they register
- Registration includes:
  - name
  - phone
  - WhatsApp number
  - alternate number
  - qualification / role
  - location
- Location is mandatory
- GPS is used when available
- If GPS fails, manually entered location acts as fallback
- Volunteer can update profile later
- Volunteer can post a new need directly from the app
- When assigned to a task, the dashboard prioritizes the active mission
- The active mission view shows:
  - problem title
  - description
  - location
  - source
  - reporter/contact details
  - task status
- Volunteer can use `Contact Reporter`
- Volunteer can use `Mark as Completed`
- On completion:
  - the need closes
  - volunteer leaves active assignment state
  - volunteer can later be re-added to a camp by a manager

### Heat Map / Location Logic

The current system already supports future heat map logic:

- when a volunteer is assigned to a need, they are occupied
- one volunteer can only handle one active task at a time
- when a task is completed, volunteer location is updated to the completed need location
- when a camp manager reassigns the volunteer back into a camp, the volunteer location changes to the camp location
- volunteer registration location acts as fallback if live GPS data is unavailable

---

## 3. Admin Dashboard Screen

The admin dashboard is the command-and-control interface.

### Main Capabilities

- Coordinator/admin login
- Overview dashboard
- Volunteer management
- Camp management
- Need management
- Role management
- Assignment lifecycle
- Camp manager selection

### Detailed Admin Flow

- Admin logs into the web dashboard
- Admin sees live operational sections such as:
  - volunteers
  - camps
  - needs
  - resources
  - map view
- Admin can manually add volunteers
- Admin can promote volunteer access roles
- Admin can create camps
- Camp creation supports accurate location capture
- Admin can assign one or multiple managers to a camp
- Admin can make self a manager
- Admin can assign volunteers to camps
- Admin can create needs manually
- Admin can review generated needs
- Admin can assign volunteers to needs
- Admin can view volunteer phone numbers from desktop
- Admin can mark needs completed or fulfilled

### Role and Camp Logic

- Volunteers can be promoted to coordinator/admin access
- Camp managers can be selected from existing volunteers
- Camp managers can also operate with elevated access after re-login
- Volunteers added manually by admin can later log in on mobile using their number
- If a volunteer is placed in a camp, their location is updated to the camp location
- If a volunteer completes a task, they are removed from camp assignment until re-added by a manager

---

## 4. Data Flow Between Both Screens

The volunteer app and admin dashboard are not separate systems.

They are two interfaces connected to the same operational backend.

### Shared Data Objects

- volunteers
- camps
- needs
- assignments
- roles
- locations
- AI-triaged requests

### Cross-Screen Sync Examples

- Admin creates a volunteer  
  The volunteer can later log in on phone with the same number

- Admin assigns a volunteer to a camp  
  Volunteer location updates to the camp location

- Volunteer posts a need  
  Admin sees the need in the dashboard

- Admin assigns a volunteer to a need  
  Volunteer app reflects the active mission

- Volunteer completes a task  
  Backend updates need status, assignment state, and volunteer location

- Camp manager re-adds volunteer to a camp  
  Volunteer location updates to camp again

---

## 5. AI / Automation Support

SevakAI includes AI-assisted triage support.

### Current AI Support

- Raw communication text can be parsed into structured disaster needs
- Backend exposes `/debug/ai-triage` for direct testing
- AI pipeline can enrich needs with structured fields such as:
  - type
  - urgency
  - summary
  - affected count

### Why This Matters

This allows the system to evolve beyond manual data entry by turning incoming communication streams into structured operational records.

---

## 6. Reviewer Walkthrough

Use this exact reviewer journey during submission/demo.

### Reviewer Script

1. Open the prototype page
2. Read the overview and two-screen explanation
3. Open backend demo page
4. Seed demo data
5. Open admin MVP
6. Login as admin
7. View volunteers, camps, and needs
8. Assign a volunteer to a need
9. Show volunteer-side mission handling on mobile or via screenshots
10. Mark the need completed
11. Return to admin view and confirm updated state

---

## 7. Submission Links

Final reviewer links should be presented together:

- `Live MVP`
- `Prototype`
- `Backend Docs`
- `Backend Demo`

Example:

- `MVP`: `https://your-admin-site.vercel.app`
- `Prototype`: `https://your-admin-site.vercel.app/prototype`
- `Backend Docs`: `https://your-api.onrender.com/docs`
- `Backend Demo`: `https://your-api.onrender.com/demo`

---

# Deployment Notes

## Backend Deployment

Deploy backend from the `backend` folder.

### Render Build Command

```bash
pip install -r requirements.txt
```

### Render Start Command

```bash
uvicorn app.main:app --host 0.0.0.0 --port $PORT
```

## Frontend Deployment

Build Flutter web from the `frontend` folder.

### Production Build

```bash
flutter build web -t lib/main.dart --dart-define=DEV_API_BASE_URL=https://YOUR-RENDER-URL/api/v1
```

Deploy the generated `build/web` directory to Vercel.

---

# Final Submission Narrative

SevakAI provides two connected operational interfaces for disaster response.

Volunteers use the mobile app to register, maintain their field profile, report needs, receive assignments, and complete missions.

Admins and coordinators use the web dashboard to create camps, manage volunteers, assign needs, monitor operations, and coordinate response execution.

Both interfaces operate on the same backend and shared data model, with AI-assisted triage support to improve future emergency intake workflows.

---

# Final Notes

- Do not rely on local JSON storage in production/demo hosting
- Use Firestore for persistent backend data
- Treat the prototype as an explanation and reviewer-guidance layer
- Keep the MVP focused on the working admin web interface
- Keep demo flows short, deterministic, and easy for judges to follow
```
