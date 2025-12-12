# 🔄 Reusability Strategy: Phase 1 → Phase 2

## 📋 **Three-Tier Reusability Approach**

### **Tier 1: Pure Shared Components (packages/shared/)**
**Never modify - Always import and use**

```dart
// ✅ CORRECT: Import and use
import 'package:mediminder_shared/models/reminder.dart';
import 'package:mediminder_shared/constants/api_endpoints.dart';

// Use directly in Flutter
final reminder = Reminder.fromJson(jsonData);
```

**What goes here:**
- Data models (Reminder, User, etc.)
- API endpoints and constants
- Pure utility functions (date formatting, validation)
- Platform-agnostic business logic

### **Tier 2: Copy-Adapt Components (apps/mobile/lib/)**
**Copy to app folder, then modify for Flutter context**

```dart
// Copy PatientReminders.js logic to:
// apps/mobile/lib/features/reminders/presentation/reminder_list_screen.dart
//
// Then adapt for Flutter:
// - React hooks → Riverpod state management
// - JSX → Flutter widgets
// - Browser APIs → Flutter plugins
```

**What gets copied:**
- UI component logic (but rewritten for Flutter)
- Platform-specific implementations
- User interaction patterns
- Navigation flows

### **Tier 3: Reference-Implement (Gradual Migration)**
**Study Phase 1, implement fresh for Phase 2**

```javascript
// Phase 1: React component
const PatientDashboard = () => {
  const [reminders, setReminders] = useState([]);
  // ... complex state management
}

// Phase 2: Flutter implementation
class PatientDashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersProvider);
    // Fresh implementation using Flutter patterns
  }
}
```

## 🗂️ **File Organization Strategy**

### **packages/shared/** (Immutable, Import-Only)
```
packages/shared/
├── constants/           # ✅ Import these
│   ├── api_endpoints.dart
│   └── ui_constants.dart
├── models/             # ✅ Import these
│   ├── reminder.dart
│   └── user.dart
├── services/           # ✅ Import these
│   └── api_service.dart
└── utils/              # ✅ Import these
    └── date_utils.dart
```

### **apps/mobile/lib/** (Adapt & Modify)
```
apps/mobile/lib/
├── core/               # App-specific core
│   ├── config/
│   └── utils/
├── features/           # Feature-based organization
│   ├── auth/          # ← Adapted from Phase 1 auth components
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── reminders/     # ← Adapted from PatientReminders.js
│   │   ├── presentation/
│   │   ├── domain/    # Business logic from Phase 1
│   │   └── data/      # API calls using shared services
│   └── dashboard/     # ← Adapted from PatientDashboard.js
└── shared/            # Mobile-specific shared (different from packages/shared)
    └── widgets/
```

### **apps/backend/** (Reference & Implement)
```
apps/backend/
├── models/            # Use shared models + add backend-specific
├── routes/
│   ├── auth.py       # ← Reference Phase 1 auth logic
│   └── reminders.py  # ← Reference PatientReminders.js patterns
└── services/
    ├── reminder_service.py  # ← Extract business logic from Phase 1
    └── ai_service.py
```

## 🔧 **Implementation Workflow**

### **Step 1: Identify Reusable Logic**
```bash
# When implementing a new feature:
1. Check Phase 1 components for similar functionality
2. Extract business logic patterns
3. Adapt for new platform (React → Flutter)
```

### **Step 2: Choose Reusability Tier**

**For New Reminder Feature:**
```dart
// 1. Use shared models (Tier 1)
import 'package:mediminder_shared/models/reminder.dart';

// 2. Copy-adapt UI logic (Tier 2)
// Copy PatientReminders.js → reminder_list_screen.dart
// Adapt: React hooks → Riverpod, JSX → Flutter widgets

// 3. Reference patterns (Tier 3)
// Study how Phase 1 handles reminder CRUD
// Implement fresh using Flutter best practices
```

### **Step 3: Implementation Process**

```dart
// Example: Implementing Patient Reminders

// Phase 1 Reference:
class PatientReminders extends React.Component {
  state = { loading: true, reminders: [] };
  async loadReminders() { /* API calls */ }
  render() { return <div>...</div>; }
}

// Phase 2 Implementation:
class ReminderListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use shared models
    final remindersAsync = ref.watch(remindersProvider);

    return remindersAsync.when(
      data: (reminders) => ReminderList(reminders: reminders),
      loading: () => CircularProgressIndicator(),
      error: (error) => ErrorView(error: error),
    );
  }
}
```

## 📊 **When to Use Each Tier**

| Scenario | Tier | Example |
|----------|------|---------|
| Data structures | 1 | Reminder model, API endpoints |
| Business logic | 1 | Reminder validation, date calculations |
| UI components | 2 | Dashboard screens, form inputs |
| Platform APIs | 2 | Camera, notifications, storage |
| Complex workflows | 3 | Multi-step processes, state machines |

## 🎯 **Best Practices**

### **✅ DO:**
- **Import shared components** - Never modify `packages/shared/`
- **Copy for adaptation** - Duplicate logic to app folders for modification
- **Reference patterns** - Study Phase 1 before implementing Phase 2
- **Document adaptations** - Note what changed and why

### **❌ DON'T:**
- **Modify shared code** - Keep `packages/shared/` immutable
- **Direct copying without adaptation** - Always consider platform differences
- **Skip reference checking** - Always check Phase 1 for proven patterns

## 🚀 **Getting Started**

### **Immediate Next Steps:**

1. **Keep shared components in packages/shared/** - These are ready to import
2. **Start with auth feature** - Copy Phase 1 auth logic to `apps/mobile/lib/features/auth/`
3. **Implement reminders** - Use shared Reminder model + adapt PatientReminders.js logic
4. **Document adaptations** - Note what changed from Phase 1 to Phase 2

### **Example Implementation:**

```bash
# 1. Use shared components
cd apps/mobile/lib
# Import: package:mediminder_shared/models/reminder.dart

# 2. Copy-adapt UI logic
cp ../../../apps/web/frontend/src/patient/PatientReminders.js features/reminders/presentation/
# Rename: reminder_list_screen.dart
# Adapt: React → Flutter patterns

# 3. Reference business logic
# Study: PatientReminders.js lines 38-50 (API calls)
# Implement: Fresh Riverpod provider using shared API service
```

## 💡 **Key Principle:**

**Shared components stay shared. App-specific code gets adapted.** This ensures:
- Consistency across platforms
- Platform-specific optimizations
- Maintainable codebase
- Proven patterns reused safely

**Ready to start implementing? Let's begin with the authentication feature!** 🎯