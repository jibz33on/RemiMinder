/// Utility functions for generating personalized greetings
class GreetingUtils {
  /// Get a time-appropriate greeting based on current hour
  static String getTimeBasedGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  /// Get a casual time-appropriate greeting
  static String getCasualTimeBasedGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }

  /// Get a personalized greeting with user's name
  static String getPersonalizedGreeting(String userName) {
    final timeGreeting = getTimeBasedGreeting();
    return '$timeGreeting, $userName! 👋';
  }

  /// Get a welcome back greeting with user's name
  static String getWelcomeBackGreeting(String userName) {
    final timeGreeting = getCasualTimeBasedGreeting();
    return 'Welcome back, $userName! Good $timeGreeting';
  }

  /// Get greeting with emoji based on time
  static String getPersonalizedGreetingWithEmoji(String userName) {
    final now = DateTime.now();
    final hour = now.hour;
    String emoji;

    if (hour >= 5 && hour < 12) {
      emoji = '🌅'; // Sunrise
    } else if (hour >= 12 && hour < 17) {
      emoji = '☀️'; // Sun
    } else if (hour >= 17 && hour < 22) {
      emoji = '🌆'; // City at dusk
    } else {
      emoji = '🌙'; // Moon
    }

    final timeGreeting = getTimeBasedGreeting();
    return '$timeGreeting, $userName! $emoji';
  }
}
