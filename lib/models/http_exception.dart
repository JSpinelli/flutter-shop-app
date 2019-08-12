class HttpException implements Exception {
  final String code;
  String message;

  HttpException(this.code) {
    if (code.contains('EMAIL_EXISTS')) {
      message = 'Email aready exists';
    } else {
      if (code.contains('INVALID_EMAIL')) {
        message = 'Email not valid';
      } else {
        if (code.contains('WEAK_PASSWORD')) {
          message = 'This password is too weak';
        } else {
          if (code.contains('EMAIL_NOT_FOUND')) {
            message = 'Could not found a user with that email';
          } else {
            if (code.contains('INVALID_PASSWORD')) {
              message = 'The passwrod is not valid';
            }else{
              message = 'An expected unexpected error has ocurred';
            }
          }
        }
      }
    }
  }

  @override
  String toString() {
    return message;
  }
}
