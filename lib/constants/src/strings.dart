import '/theme/theme.dart';
import '/models/models.dart';

class AppStrings {
  // ── New Firebase project (set these after creating the project) ──────────
  static const String firebaseProjectId = "crm-app-7a00e";
  static const String functionsRegion = "us-central1";
  static const String functionsBaseUrl =
      "https://$functionsRegion-$firebaseProjectId.cloudfunctions.net";

  static const String updatePasswordUrl = "$functionsBaseUrl/updateUserPassword";
  static const String deleteUserUrl = "$functionsBaseUrl/deleteUserByEmail";
  static const String sendEmailUrl = "$functionsBaseUrl/sendEmail";

  // SMTP used by the sendEmail function (move to a secret store for production)
  static const String smtpUser = "systemadmin@srisoftwarez.com";
  static const String smtpPass = "mxlfsavbqgrbhmrq";

  static const String emptyProfilePhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/$firebaseProjectId.firebasestorage.app/o/static%2Fuser-profile-icon.png?alt=media";

  static const String androidfacesdkLicence =
      "wWevuh/4kYz0O/XvtfJv0O0IvTJao7E4XWnKBLpQ32+bwH3GRmBGgY3RXHjQlukOsZiW/Y8uhGr8"
      "zFGb/I3AoO53qLRUbGX8BV50AF3fGXTmmoY8uj8ZKqOF7OJWZZgSEyZs36r+0kxDRiApdZa20jhq"
      "fZ56VbL+TDkA9fWu4w0EJYKsSr/t5k9hE2vfuPDczPigr0q3aZyqCvXm1foKDsCzJ2WFD2MBZy/F"
      "g/smbQLFXJmo/o8e+F64bzMc4Hf/qWvXzzCbnVVdaZPr2BTWXZ2SEpPLf6triL+tvURcUVaVP0M2"
      "qPB27Gja5dunn4PhEEtTDn1RWtFPfk7vJAmhyg==";

  static const String iosfacesdkLicence =
      "Z6g7MbPXuE/V8YKMxJI60L+SdnAjz6rgtyZ4CWFa2xwU3P91D6Ih0jg70qxcT856LI7TwUlQbfYs0"
      "LrEW+9B2gAeSzYHa6LQIRbSNJ5BBZ13WmOPJglJSB7G1CSYTc6YPl1ioKS0o0Vh5SwSKh5oXhavSq"
      "c2ClL6Uu4kAxKO/jE+l/EC8ifvVX5oo8HUQ/H76I0eMig8yDq9Wvci6U7IxWMZlRjCtTiZvE/nC73"
      "6sY7d/DgYhu7/i9BkRkdslvEAfi6Mcc2tOcGHX3TpZ0dv5K8bOunVt6Fe6aDAtwypeovE8nL+NRpt"
      "8L90fO1s6MRMT6gez2der2aiv2vSSo+J0g==";

  static List<String> spokenLanguages = [
    "English",
    "Mandarin Chinese",
    "Hindi",
    "Spanish",
    "French",
    "Modern Standard Arabic",
    "Bengali",
    "Portuguese",
    "Russian",
    "Urdu",
    "Indonesian",
    "German",
    "Japanese",
    "Swahili",
    "Marathi",
    "Telugu",
    "Turkish",
    "Tamil",
    "Vietnamese",
    "Korean",
    "Italian",
    "Cantonese",
    "Thai",
    "Gujarati",
    "Polish",
    "Ukrainian",
    "Persian (Farsi)",
    "Malay",
    "Dutch",
    "Filipino (Tagalog)",
    "Romanian",
    "Pashto",
    "Malayalam",
    "Kannada",
    "Burmese",
    "Sindhi",
    "Nepali",
    "Sinhalese",
    "Czech",
    "Swedish",
    "Greek",
    "Hungarian",
    "Finnish",
    "Danish",
    "Norwegian",
    "Hebrew",
    "Lao",
    "Khmer",
    "Hausa",
    "Zulu",
    "Afrikaans",
    "Somali",
    "Amharic",
    "Bhojpuri",
    "Rajasthani",
    "Punjabi",
    "Assamese",
    "Odia",
    "Maithili",
    "Kashmiri",
    "Konkani",
    "Santali",
    "Tibetan",
    "Mongolian",
    "Serbian",
    "Croatian",
    "Slovak",
    "Bulgarian",
    "Bosnian",
    "Slovenian",
    "Albanian",
    "Latvian",
    "Lithuanian",
    "Estonian",
    "Icelandic",
    "Irish",
    "Welsh",
    "Scottish Gaelic",
    "Catalan",
    "Basque",
    "Galician",
    "Haitian Creole",
    "Luxembourgish",
    "Samoan",
    "Tongan",
    "Fijian",
    "Maori",
    "Khasi",
    "Dzongkha",
    "Tigrinya",
    "Yoruba",
    "Igbo",
    "Shona",
    "Chewa",
    "Xhosa",
  ];

  static List<String> accessPagesList = [
    "Dashboard",
    "Role",
    "Designation",
    "Department",
    "Sub Department",
    "Employees",
    "Chats",
    "Lead Category",
    "Lead Source",
    "Lead Status",
    "Lead Priority",
    "Deal Status",
    "Leads",
    "Deals",
    "Company",
    "Contact",
    "Calendar",
    "Projects",
    "Tasks",
    "Tickets",
    "Downloads",
    "Developer Area",
    "Login Logs",
    "Activity Logs",
  ];

  static List<String> pagesWithImportExport = [
    "Employees",
    "Leads",
    "Clients",
    "Company",
    "Admin",
  ];

  static List<PermissionModel> permissionsTrueMap = List.generate(
    accessPagesList.length,
    (index) {
      return PermissionModel(
        page: accessPagesList[index],
        canView: true,
        canCreate: true,
        canDelete: true,
        canEdit: true,
      );
    },
  );
}

class PlaceholderImage {
  static String fetchImage(String letter) {
    final upper = letter.toUpperCase();
    // ignore: deprecated_member_use
    return "https://placehold.co/100x100/${LetterColors.getColor(upper).value.toRadixString(16).padLeft(8, '0').substring(2)}/FFFFFF/png?text=$upper";
  }
}
