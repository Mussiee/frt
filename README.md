# Focus-
###  Our Git Workflow Guide

This project follows a simple Git workflow to keep development clean, organized, and easy to collaborate on between frontend and backend teams.

---

#  Branching Strategy

We use a basic Git Flow structure:

##  Main Branches

### `main`
- Production-ready code only
- Always stable
- No direct commits allowed

### `dev`
- Integration branch for ongoing development
- All features are merged here before going to production
- Used for testing full application flow

---

##  Feature Branches

All work must be done in separate feature branches.

### Naming convention (flexible but clear):
- `feature/login`
- `feature/payment`
- `backend/auth`
- `frontend/dashboard`
- `fix/navbar-bug`

> Branch naming is not strict, but should clearly describe the work.

---

##  Workflow

1. Pull latest changes:
   ```bash
   git checkout dev
   git pull origin dev
