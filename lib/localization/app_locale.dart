// All localization strings are defined here as Dart maps.
// To add a new language:
//   1. Add a new Map<String, dynamic> below
//   2. Add MapLocale('xx', AppLocale.xx) in main.dart init
//
// Usage in widgets:
//   context.formatString(AppLocale.dashboardTitle, [])

mixin AppLocale {
  // ── String keys ──────────────────────────────────────────────────────────
  static const String appTitle = 'appTitle';
  static const String dashboardTitle = 'dashboardTitle';
  static const String welcomeBack = 'welcomeBack';
  static const String selectFeature = 'selectFeature';

  // Feature cards
  static const String userCrud = 'userCrud';
  static const String userCrudDesc = 'userCrudDesc';
  static const String analytics = 'analytics';
  static const String analyticsDesc = 'analyticsDesc';
  static const String settings = 'settings';
  static const String settingsDesc = 'settingsDesc';
  static const String profile = 'profile';
  static const String profileDesc = 'profileDesc';
  static const String notifications = 'notifications';
  static const String notificationsDesc = 'notificationsDesc';
  static const String helpSupport = 'helpSupport';
  static const String helpSupportDesc = 'helpSupportDesc';
  static const String moreFeaturesSoon = 'moreFeaturesSoon';

  // AppBar actions
  static const String switchToLightMode = 'switchToLightMode';
  static const String switchToDarkMode = 'switchToDarkMode';
  static const String switchToBangla = 'switchToBangla';
  static const String switchToEnglish = 'switchToEnglish';

  // User CRUD
  static const String userManagement = 'userManagement';
  static const String addUser = 'addUser';
  static const String editUser = 'editUser';
  static const String deleteUser = 'deleteUser';
  static const String noUsersYet = 'noUsersYet';
  static const String addFirstUser = 'addFirstUser';
  static const String name = 'name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String deleteConfirmTitle = 'deleteConfirmTitle';
  static const String deleteConfirmMessage = 'deleteConfirmMessage';

  // Coming soon
  static const String comingSoon = 'comingSoon';
  static const String comingSoonDesc = 'comingSoonDesc';
  static const String backToDashboard = 'backToDashboard';

  // ── English translations ──────────────────────────────────────────────────
  static const Map<String, dynamic> en = {
    appTitle: 'Clean Riverpod',
    dashboardTitle: 'Dashboard',
    welcomeBack: 'Welcome Back! 👋',
    selectFeature: 'Select a feature to get started',
    userCrud: 'User CRUD',
    userCrudDesc: 'Manage user information',
    analytics: 'Analytics',
    analyticsDesc: 'View statistics & reports',
    settings: 'Settings',
    settingsDesc: 'Configure your preferences',
    profile: 'Profile',
    profileDesc: 'Manage your profile',
    notifications: 'Notifications',
    notificationsDesc: 'Check notifications',
    helpSupport: 'Help & Support',
    helpSupportDesc: 'Get help and support',
    moreFeaturesSoon: 'More features coming soon!',
    switchToLightMode: 'Switch to Light Mode',
    switchToDarkMode: 'Switch to Dark Mode',
    switchToBangla: 'বাংলায় পরিবর্তন করুন',
    switchToEnglish: 'Switch to English',
    userManagement: 'User Management',
    addUser: 'Add User',
    editUser: 'Edit User',
    deleteUser: 'Delete User',
    noUsersYet: 'No users yet',
    addFirstUser: 'Tap + to add your first user',
    name: 'Name',
    email: 'Email',
    phone: 'Phone',
    save: 'Save',
    cancel: 'Cancel',
    delete: 'Delete',
    deleteConfirmTitle: 'Delete User',
    deleteConfirmMessage: 'Are you sure you want to delete this user?',
    comingSoon: 'Coming Soon 🚀',
    comingSoonDesc: 'This feature is under development.\nCheck back soon!',
    backToDashboard: 'Back to Dashboard',
  };

  // ── Bangla translations ───────────────────────────────────────────────────
  static const Map<String, dynamic> bn = {
    appTitle: 'ক্লিন রিভারপড',
    dashboardTitle: 'ড্যাশবোর্ড',
    welcomeBack: 'স্বাগতম! 👋',
    selectFeature: 'শুরু করতে একটি ফিচার নির্বাচন করুন',
    userCrud: 'ব্যবহারকারী ম্যানেজমেন্ট',
    userCrudDesc: 'ব্যবহারকারীর তথ্য পরিচালনা করুন',
    analytics: 'বিশ্লেষণ',
    analyticsDesc: 'পরিসংখ্যান ও রিপোর্ট দেখুন',
    settings: 'সেটিংস',
    settingsDesc: 'আপনার পছন্দ কনফিগার করুন',
    profile: 'প্রোফাইল',
    profileDesc: 'আপনার প্রোফাইল পরিচালনা করুন',
    notifications: 'নোটিফিকেশন',
    notificationsDesc: 'নোটিফিকেশন দেখুন',
    helpSupport: 'সাহায্য ও সাপোর্ট',
    helpSupportDesc: 'সাহায্য এবং সাপোর্ট পান',
    moreFeaturesSoon: 'আরো ফিচার শীঘ্রই আসছে!',
    switchToLightMode: 'লাইট মোডে পরিবর্তন করুন',
    switchToDarkMode: 'ডার্ক মোডে পরিবর্তন করুন',
    switchToBangla: 'বাংলায় পরিবর্তন করুন',
    switchToEnglish: 'ইংরেজিতে পরিবর্তন করুন',
    userManagement: 'ব্যবহারকারী ম্যানেজমেন্ট',
    addUser: 'ব্যবহারকারী যোগ করুন',
    editUser: 'ব্যবহারকারী সম্পাদনা করুন',
    deleteUser: 'ব্যবহারকারী মুছুন',
    noUsersYet: 'এখনো কোনো ব্যবহারকারী নেই',
    addFirstUser: 'প্রথম ব্যবহারকারী যোগ করতে + চাপুন',
    name: 'নাম',
    email: 'ইমেইল',
    phone: 'ফোন',
    save: 'সংরক্ষণ করুন',
    cancel: 'বাতিল',
    delete: 'মুছুন',
    deleteConfirmTitle: 'ব্যবহারকারী মুছুন',
    deleteConfirmMessage: 'আপনি কি এই ব্যবহারকারীকে মুছে ফেলতে চান?',
    comingSoon: 'শীঘ্রই আসছে 🚀',
    comingSoonDesc: 'এই ফিচারটি এখনো তৈরি হচ্ছে।\nশীঘ্রই আসছে!',
    backToDashboard: 'ড্যাশবোর্ডে ফিরুন',
  };
}
