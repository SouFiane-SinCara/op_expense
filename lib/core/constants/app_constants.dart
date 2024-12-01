class AppConstants {
  static const String termsAndConditionsWebSiteLink =
      'https://www.register.it/company/legal/condizioni-generali.html?lang=en';
  // for name validation
  static RegExp nameValidationRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  // for email validation 
  static RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+(\.[a-zA-Z]+)?$');
      
}
