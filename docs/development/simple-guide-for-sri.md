# 🚀 **Simple Guide for Sri: How to Use Our New Folders**

Hey Sri! Here's an easy guide to understand our new folder structure and how to use everything. I'll explain it like we're building a house together.

---

## 🏠 **Think of Our Project Like a House**

```
MediMinder Project (the whole house)
├── packages/shared/     ← The "foundation" - everyone uses this
├── apps/               ← The "rooms" - different parts of the house
│   ├── mobile/         ← Flutter app (iOS/Android room)
│   ├── backend/        ← FastAPI server (kitchen)
│   └── web/           ← React web app (living room)
└── docs/              ← The "blueprints" - how to build everything
```

---

## 📦 **packages/shared/ - The Foundation (Everyone Uses This)**

**What it is:** Like the foundation, plumbing, and electricity of our house. Every part of the project uses these pieces.

**How to use it:**

### 🎯 **If you're building the MOBILE app (Flutter):**
```dart
// Just copy-paste these imports - they work everywhere!
import 'package:mediminder_shared/models/reminder.dart';
import 'package:mediminder_shared/utils/validation_utils.dart';
import 'package:mediminder_shared/constants/api_endpoints.dart';

// Example: Create a reminder
final reminder = Reminder(
  id: '123',
  title: 'Take medicine',
  type: ReminderType.medication,
  // ... more fields
);

// Example: Check if email is valid
bool isValid = ValidationUtils.isValidEmail('user@email.com');
```

### 🐍 **If you're building the BACKEND (Python):**
```python
# Just import and use - same as Flutter!
from shared.models.reminder import Reminder
from shared.utils.validation_utils import ValidationUtils
from shared.constants.api_endpoints import ApiEndpoints

# Example: Create a reminder
reminder = Reminder(
    id='123',
    title='Take medicine',
    reminder_type='medication'
)

# Example: Check validation
is_valid = ValidationUtils.is_valid_email('user@email.com')
```

---

## 📱 **apps/mobile/ - The Flutter App Room**

**What it is:** This is where we build the iOS/Android app that people will download.

**What's inside:**
```
apps/mobile/lib/
├── features/           ← Different app sections (like rooms)
│   └── reminders/      ← Reminder feature (already built!)
│       ├── data/       ← API calls and database stuff
│       └── presentation/ ← What users see (screens)
└── shared/             ← Reusable pieces for the mobile app
    └── widgets/        ← UI components (buttons, cards, etc.)
```

**How to use it:**

### 📋 **Copy the Reminder Feature Pattern**
```bash
# When building a new feature (like "patient profile"):

# 1. Copy the reminders folder structure
cp -r apps/mobile/lib/features/reminders apps/mobile/lib/features/patient_profile

# 2. Rename files
mv patient_profile/data/reminder_repository.dart patient_profile/data/profile_repository.dart

# 3. Change the code inside (but keep the same structure)
```

### 🎨 **Use the Shared Widgets**
```dart
// Import reusable UI pieces
import '../shared/widgets/reminder_card.dart';

// Use them in your screens
ReminderCard(
  reminder: myReminder,
  onComplete: () => print('Completed!'),
)
```

---

## 🖥️ **apps/backend/ - The Server Kitchen**

**What it is:** This is the FastAPI server that handles all the data and business logic.

**How to use it:**
```python
# Use shared components here too!
from shared.models.reminder import Reminder, ReminderStatus
from shared.utils.validation_utils import ValidationUtils

@app.post("/reminders")
def create_reminder(data: dict):
    # Use shared validation
    if not ValidationUtils.is_valid_medication_name(data['name']):
        return {"error": "Invalid medication name"}

    # Use shared models
    reminder = Reminder(**data)
    # ... save to database
```

---

## 📚 **docs/ - The Blueprints**

**What it is:** Instructions and plans for how to build everything.

**Important files to read:**
- `docs/development/reusability-strategy.md` - **MUST READ FIRST** - explains the 3 ways to reuse code
- `docs/development/phase1-reusability-analysis.md` - what we can reuse from the old React app
- `docs/development/roadmap.md` - what's next to build

---

## 🔄 **The 3 Simple Ways to Reuse Code**

### **Way 1: "Just Use It" (Easiest)**
```dart
// For shared components - just import and use!
import 'package:mediminder_shared/models/reminder.dart';

// No changes needed - works everywhere
```

### **Way 2: "Copy and Change" (Medium)**
```bash
# Copy existing code and modify it
cp apps/mobile/lib/features/reminders apps/mobile/lib/features/new_feature

# Then change the code inside for your specific need
# Like: reminder → appointment, medicine → task, etc.
```

### **Way 3: "Look and Learn" (Advanced)**
```javascript
// Study old React code first
// Look at: apps/web/frontend/src/patient/PatientReminders.js

// Then build fresh with new patterns
// But use the same ideas: validation, error handling, etc.
```

---

## 🛠️ **Quick Start: Build Your First Feature**

### **Step 1: Pick what to build**
- Look at `docs/development/roadmap.md` for ideas
- Or ask Jibin what needs to be built next

### **Step 2: Use shared pieces**
```dart
// Always start with these imports
import 'package:mediminder_shared/models/reminder.dart';
import 'package:mediminder_shared/utils/validation_utils.dart';
import 'package:mediminder_shared/constants/api_endpoints.dart';
```

### **Step 3: Copy a pattern**
```bash
# Copy the reminders feature as your starting point
cp -r apps/mobile/lib/features/reminders apps/mobile/lib/features/my_feature

# Rename files and change the code inside
```

### **Step 4: Test with shared validation**
```dart
// Use shared validation everywhere
if (!ValidationUtils.isValidEmail(email)) {
  showError('Invalid email');
}
```

---

## 🤔 **Questions to Ask Yourself**

### **"Where should I put my new code?"**
- **Shared logic?** → `packages/shared/`
- **Mobile app only?** → `apps/mobile/lib/`
- **Backend only?** → `apps/backend/`
- **Documentation?** → `docs/`

### **"How do I reuse existing code?"**
- **Shared models/constants?** → Just import them
- **UI patterns?** → Copy and modify
- **Business logic?** → Study old code, build fresh

### **"What if I'm stuck?"**
1. Check `docs/development/reusability-strategy.md`
2. Look at the reminders feature as an example
3. Ask Jibin for help!

---

## 🎯 **Key Takeaways**

1. **packages/shared/** = Foundation - everyone uses this, never change it
2. **apps/mobile/** = Flutter app - copy patterns from here
3. **apps/backend/** = Server - use shared pieces here too
4. **docs/** = Instructions - read these first

**Start by copying the reminders feature and modifying it for your needs!** 🚀

---

*This guide is simple on purpose. If something doesn't make sense, ask Jibin to explain it!*</contents>
</xai:function_call">Write">
<parameter name="path">/Users/jibinkunjumon/developments/MediMinder/docs/development/simple-guide-for-sri.md