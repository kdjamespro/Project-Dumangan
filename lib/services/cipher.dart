import 'package:encryptor/encryptor.dart';

class Cipher {
//  r4u7x!A%D*G-KaPdSgVkYp3s6v8y/B?E

  static String encryptAES(plainText) {
    var key = 'r4u7x!A%D*G-KaPdSgVkYp3s6v8y/B?E';

    var encrypted = Encryptor.encrypt(key, plainText);
    return encrypted;
  }

  static String decryptAES(plainText) {
    var key = 'r4u7x!A%D*G-KaPdSgVkYp3s6v8y/B?E';
    var decrypted = Encryptor.decrypt(key, plainText);
    return decrypted;
  }
}
