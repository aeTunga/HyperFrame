# 🛠 HyperConsole - Runtime Developer Cockpit

> **Your Built-in Debugging Suite - Zero Configuration, Maximum Power**

HyperConsole is HyperFrame's killer feature: a comprehensive in-app developer dashboard accessible with a single tap. No external tools needed - test APIs, inspect cache, debug navigation, and monitor logs all within your running app.

**TODO:** Add screenshot showing HyperConsole open with all tabs visible

---

## 🎯 Quick Access

### Opening HyperConsole

Look for the **blue floating button** in the bottom-left corner of your app (debug mode only).

- **Tap** → Opens HyperConsole
- **Long Press + Drag** → Repositions the button

The button is only visible in debug mode and is completely stripped from release builds.

**See screenshots in [README.md](../README.md#-hyperconsole-overview) for visual examples of all tabs.**

---

## 📱 The 5 Power Tabs

### 1️⃣ Network Tester Tab

Test your APIs without leaving the app. No Postman needed!

**Features:**
- **Live API Testing** - Full REST client (GET, POST, PUT, DELETE, PATCH)
- **Request History** - Last 10 requests automatically saved
- **Mock Data Generation** - Built-in test user generator
- **Custom Headers** - Add authentication tokens, content types, etc.
- **Response Viewer** - Formatted JSON with status codes
- **Error Handling** - See exactly what went wrong

**Example Use Cases:**
```dart
// Test your authentication endpoint
POST https://api.example.com/auth/login
Headers: { "Content-Type": "application/json" }
Body: { "email": "test@example.com", "password": "secret123" }

// Verify API responses before implementing UI
GET https://api.example.com/users/123

// Debug failed requests
DELETE https://api.example.com/posts/456
```

**Pro Tips:**
- Use "Generate Mock User" to quickly create test data
- History persists during your debug session
- Copy response JSON for frontend development
- Test error handling with invalid endpoints

---

### 2️⃣ Cache Viewer Tab

Inspect and manipulate your app's local storage in real-time.

**Features:**
- **View All Cache** - See every stored key-value pair
- **Search Filter** - Find specific cache entries instantly
- **Individual Clear** - Remove single items with trash icon
- **Bulk Clear** - Wipe all cache with one tap
- **Type Display** - Shows data types (String, int, bool, etc.)
- **Live Updates** - Refreshes when cache changes

**Common Cache Keys:**
```dart
// App preferences
"theme_mode"           → ThemeMode enum
"user_preferences"     → JSON settings

// Session data
"auth_token"           → JWT token
"user_id"              → Current user ID

// Feature flags
"onboarding_complete"  → bool
"beta_features"        → List<String>
```

**Pro Tips:**
- Use search to debug persistence issues
- Clear cache to test first-run experience
- Verify data is being saved correctly
- Test app behavior with missing cache

---

### 3️⃣ Device & Theme Tab

Test themes and view device information without rebuilding.

**Features:**
- **Live Theme Switching** - Instantly preview light/dark/system modes
- **Device Information** - Screen size, pixel ratio, platform
- **Safe Area Display** - View padding/insets
- **Brightness Control** - Test different brightness scenarios
- **Real-time Updates** - Changes reflect immediately

**Information Displayed:**
```dart
Platform:        iOS 18.0 (Simulated iPhone 16 Pro Max)
Screen Size:     430.0 x 932.0 logical pixels
Pixel Ratio:     3.0x (1290 x 2796 physical pixels)
Text Scale:      1.0x
Brightness:      Dark Mode
Safe Area:       Top: 59.0, Bottom: 34.0
```

**Pro Tips:**
- Rapidly test theme consistency
- Verify safe area handling on notched devices
- Check text scaling for accessibility
- Validate responsive breakpoints

---

### 4️⃣ Router Manager Tab ⭐ NEW

Debug navigation with browser-like history and favorites.

**Features:**
- **Current Route Display** - Live updates as you navigate
- **Manual Navigation** - Type any route path and GO
- **Back/Forward Buttons** - Browser-style navigation controls
- **Navigation History** - Last 20 routes (FIFO, session-only)
- **Favorite Routes** - Star frequently used routes (persists across restarts)
- **Quick Access Chips** - One-tap navigation to common routes
- **Route Parameters** - Full support for `/user/123?edit=true` syntax
- **History Position** - Shows your position in history (e.g., "3/10")

**Example Usage:**
```dart
// Navigate to specific user profile
/user/123

// Open edit mode with query params
/profile?edit=true

// Deep link testing
/products/category/electronics?sort=price&filter=sale

// Test navigation edge cases
/admin/dashboard/analytics?date=2025-01-01
```

**Navigation Controls:**
- **← Back** - Navigate to previous route (if available)
- **→ Forward** - Navigate to next route (if available)
- **⭐ Star** - Add current route to favorites
- **GO Button** - Navigate to typed route
- **Quick Chips** - Tap `/` or `/home` for instant navigation

**Pro Tips:**
- Favorite your most-used development routes
- Use history to reproduce navigation bugs
- Test deep linking without external tools
- Verify route parameters are parsed correctly
- Console stays open after navigation for convenience

---

### 5️⃣ Logger Tab

Real-time application logs with filtering and search.

**Features:**
- **Live Log Stream** - See logs as they happen
- **Log Levels** - Info, Warning, Error with color coding
- **Search Filter** - Find specific log messages
- **Auto-scroll** - Follows latest logs (toggle on/off)
- **Copy Logs** - Export for bug reports
- **Clear Logs** - Fresh start with one tap

**Log Format:**
```
[02:45:12] INFO: User logged in successfully
[02:45:15] WARN: Cache miss for key: user_preferences
[02:45:18] ERROR: Network request failed: timeout
```

**Integration Example:**
```dart
import 'package:hyperframe/core/init/log_helper.dart';

// In your code
LogHelper.info('User performed action: $action');
LogHelper.warning('Deprecated API call detected');
LogHelper.error('Failed to save data', error: e, stackTrace: stackTrace);
```

**Pro Tips:**
- Filter by log level to focus on errors
- Use search to find specific operations
- Clear logs before testing new features
- Copy logs for bug reports or documentation

---

## 🎨 Design Philosophy

### Always Available, Never Intrusive

- **Zero Configuration** - Works out of the box
- **Debug-Only** - Completely stripped from release builds
- **Persistent Access** - Button visible on all screens
- **Non-Blocking** - Console stays open while testing
- **Draggable Button** - Position it where you need it

### Performance First

- **Lazy Loading** - Tabs only load when opened
- **Efficient Rendering** - Minimal rebuild overhead
- **Memory Safe** - Limited history to prevent leaks
- **Production Safe** - No console code in release builds

---

## 🚀 Advanced Usage

### Integrating with Your Code

#### Using NetworkManager

```dart
import 'package:hyperframe/core/network/network_manager.dart';
import 'package:hyperframe/core/network/http_method.dart';

// Get NetworkManager instance
final networkManager = NetworkManager();

// Make type-safe requests
final response = await networkManager.request<User>(
  '/users/123',
  method: HttpMethod.get,
  parser: (json) => User.fromJson(json),
);

// Handle response
response.when(
  success: (user) => print('User: ${user.name}'),
  failure: (error) => print('Error: ${error.message}'),
);
```

#### Using CacheManager

```dart
import 'package:hyperframe/core/caching/cache_manager.dart';

final cacheManager = CacheManager();

// Store data
await cacheManager.setString('user_token', 'abc123');
await cacheManager.setInt('user_id', 42);
await cacheManager.setBool('onboarding_complete', true);

// Store JSON objects
await cacheManager.setJson('user_profile', user.toJson());

// Retrieve data
final token = await cacheManager.getString('user_token');
final userId = await cacheManager.getInt('user_id');
final profile = await cacheManager.getJson('user_profile');

// Check existence
final hasToken = await cacheManager.containsKey('user_token');

// Clear specific key
await cacheManager.remove('user_token');

// Clear all cache
await cacheManager.clear();
```

#### Custom Logging

```dart
import 'package:hyperframe/core/init/log_helper.dart';

class MyService {
  Future<void> processData() async {
    LogHelper.info('Starting data processing...');
    
    try {
      // Your logic here
      LogHelper.info('Data processed successfully');
    } catch (e, stackTrace) {
      LogHelper.error('Processing failed', error: e, stackTrace: stackTrace);
    }
  }
}
```

---

## 🔧 Configuration

### Customizing Cache Keys

Add your own cache keys to `lib/core/constants/cache_keys.dart`:

```dart
class CacheKeys {
  // Existing keys
  static const String themeMode = 'theme_mode';
  static const String hyperConsoleFavoriteRoutes = 'hyper_console_favorite_routes';
  
  // Add your custom keys
  static const String userToken = 'user_token';
  static const String lastSyncTime = 'last_sync_time';
  static const String featureFlags = 'feature_flags';
}
```

### Adding Quick Access Routes

Edit `lib/core/console/widgets/tabs/router_tab.dart`:

```dart
// Around line 200 - Quick Access Section
final quickAccessRoutes = [
  '/',           // Home
  '/home',       // Home (alternate)
  '/profile',    // Add your routes
  '/settings',
  '/admin/dashboard',
];
```

---

## 💡 Pro Tips & Tricks

### 1. Network Tab Workflow

```
1. Generate mock user → Copy JSON
2. Paste into request body
3. Send to your API
4. Verify response in app UI
5. Check history to reproduce issues
```

### 2. Cache Debugging

```
1. Make a change in your app
2. Open Cache tab
3. Search for related keys
4. Verify data is correct
5. Clear cache to test persistence
```

### 3. Router Testing

```
1. Star your main development routes
2. Use favorites for quick navigation
3. Test deep links with query params
4. Use back/forward to reproduce navigation bugs
5. Check history to understand navigation flow
```

### 4. Theme Consistency

```
1. Open Device tab
2. Toggle between light/dark
3. Navigate through your app
4. Verify colors are consistent
5. Test with system theme setting
```

### 5. Log-Driven Development

```
1. Add LogHelper calls at key points
2. Open Logger tab
3. Perform actions in your app
4. Watch logs flow in real-time
5. Filter to focus on specific areas
```

---

## 🐛 Troubleshooting

### HyperConsole Button Not Visible

**Symptoms:** Can't find the blue button

**Solutions:**
- Verify you're running in **debug mode** (`flutter run -d macos`)
- Check you're on a **desktop platform** (macOS/Windows/Linux)
- Hot restart with `R` in the terminal
- Button only appears with DevicePreview enabled

### Navigator Errors

**Symptoms:** Error when opening console

**Solutions:**
- This should be fixed with ShellRoute architecture
- If you see errors, restart the app with `R`
- Ensure you've run `dart run build_runner build --delete-conflicting-outputs`

### Cache Not Persisting

**Symptoms:** Cache clears between app restarts

**Solutions:**
- Verify CacheManager is initialized in `app_initializer.dart`
- Check you're using correct cache keys
- Use CacheViewer tab to verify data is being saved
- Ensure you're not running in browser (uses different storage)

### Network Requests Failing

**Symptoms:** All requests timeout or fail

**Solutions:**
- Check your internet connection
- Verify API endpoint URLs are correct
- Check CORS settings if testing web APIs
- Look at error messages in response viewer
- Use `flutter run -v` for verbose network logs

---

## 🎓 Learning Resources

### Understanding the Architecture

- **ShellRoute Injection:** Button is injected via GoRouter's ShellRoute
- **Navigator Access:** Context has Navigator because it's inside GoRouter's tree
- **Debug-Only:** `kDebugMode` guard ensures zero production overhead
- **Persistence:** Favorites use CacheManager, history is in-memory

### Key Files

```
lib/core/console/
├── widgets/
│   ├── tabs/
│   │   ├── network_tester_tab.dart      # Network testing UI
│   │   ├── cache_viewer_tab.dart        # Cache inspection
│   │   ├── device_theme_tab.dart        # Theme & device info
│   │   ├── router_tab.dart              # Navigation debugging ⭐
│   │   └── logger_tab.dart              # Live logs
│   ├── hyper_console_button.dart        # Floating button
│   └── hyper_console_sheet.dart         # Bottom sheet container
└── models/
    ├── network_test_result.dart         # Network response model
    └── test_user_model.dart             # Mock user data
```

---

## 🤝 Contributing

Want to add a new tab or feature to HyperConsole?

### Adding a New Tab

1. Create new tab file: `lib/core/console/widgets/tabs/my_tab.dart`
2. Implement tab UI with your debugging tools
3. Add tab to `hyper_console_sheet.dart`:

```dart
DefaultTabController(
  length: 6,  // Increment count
  child: TabBar(
    tabs: [
      // Existing tabs...
      Tab(icon: Icon(Icons.my_icon), text: 'MyTab'),  // Add yours
    ],
  ),
  child: TabBarView(
    children: [
      // Existing tabs...
      MyTab(),  // Add yours
    ],
  ),
),
```

### Best Practices

- Follow Material 3 design patterns
- Add search/filter for list-heavy tabs
- Use proper error handling
- Add helpful empty states
- Test in both light and dark themes
- Document your tab in this file

---

## 📊 Feature Comparison

| Feature | HyperConsole | External Tools |
|---------|-------------|----------------|
| **API Testing** | ✅ Built-in | Postman, Insomnia |
| **Cache Inspection** | ✅ Built-in | Custom debug screens |
| **Theme Testing** | ✅ Instant | Rebuild required |
| **Navigation Debug** | ✅ Live history | Manual tracking |
| **Live Logging** | ✅ Built-in | Console logs only |
| **Access** | 1 tap | Launch separate app |
| **Context** | Full app state | No app context |
| **Speed** | Instant | Alt+Tab delay |

---

## 🌟 Why HyperConsole Matters

### For Solo Developers
- No need to switch between multiple tools
- Test everything within your running app
- Faster iteration cycles
- Catch bugs earlier

### For Teams
- Consistent debugging experience
- Shareable testing workflows
- Easier bug reproduction
- Better QA integration

### For Production Apps
- Zero overhead (debug-only)
- No external dependencies
- Clean separation of concerns
- Professional debugging experience

---

**HyperConsole: Because great apps deserve great tools.** 🚀

*Built with ❤️ for developers who refuse to compromise.*
