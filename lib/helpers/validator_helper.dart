import 'package:email_validator/email_validator.dart';

String emailValidator(String email) {
  if (email.isEmpty || !EmailValidator.validate(email)) return "Podany adres e-mail nie jest prawidłowy";

  return null;
}
