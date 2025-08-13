import 'package:flutter_test/flutter_test.dart';
import 'package:sky_eldercare_family/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('isEmail', () {
      test('should return true for valid email addresses', () {
        expect(Validators.isEmail('test@example.com'), true);
        expect(Validators.isEmail('user.name@domain.co.uk'), true);
        expect(Validators.isEmail('test123@test.org'), true);
      });

      test('should return false for invalid email addresses', () {
        expect(Validators.isEmail('invalid.email'), false);
        expect(Validators.isEmail(''), false);
        expect(Validators.isEmail('@domain.com'), false);
        expect(Validators.isEmail('user@'), false);
        expect(Validators.isEmail('user@domain'), false);
      });
    });

    group('isPhoneNumber', () {
      test('should return true for valid Chinese phone numbers', () {
        expect(Validators.isPhoneNumber('13812345678'), true);
        expect(Validators.isPhoneNumber('15987654321'), true);
        expect(Validators.isPhoneNumber('18765432109'), true);
      });

      test('should return false for invalid phone numbers', () {
        expect(Validators.isPhoneNumber('12345678901'), false);
        expect(Validators.isPhoneNumber('1381234567'), false);
        expect(Validators.isPhoneNumber(''), false);
        expect(Validators.isPhoneNumber('abcdefghijk'), false);
      });
    });

    group('isStrongPassword', () {
      test('should return true for strong passwords', () {
        expect(Validators.isStrongPassword('StrongP@ss1'), true);
        expect(Validators.isStrongPassword('MySecure123'), true);
        expect(Validators.isStrongPassword('Password1234'), true);
      });

      test('should return false for weak passwords', () {
        expect(Validators.isStrongPassword('weak'), false);
        expect(Validators.isStrongPassword('password'), false);
        expect(Validators.isStrongPassword('PASSWORD'), false);
        expect(Validators.isStrongPassword('12345678'), false);
        expect(Validators.isStrongPassword(''), false);
      });
    });

    group('isUsername', () {
      test('should return true for valid usernames', () {
        expect(Validators.isUsername('user123'), true);
        expect(Validators.isUsername('test_user'), true);
        expect(Validators.isUsername('admin'), true);
        expect(Validators.isUsername('user_name_123'), true);
      });

      test('should return false for invalid usernames', () {
        expect(Validators.isUsername('us'), false); // too short
        expect(Validators.isUsername('thisusernameistoolongtobevalid'), false); // too long
        expect(Validators.isUsername('user-name'), false); // contains dash
        expect(Validators.isUsername('user name'), false); // contains space
        expect(Validators.isUsername(''), false); // empty
      });
    });

    group('isNumeric', () {
      test('should return true for numeric strings', () {
        expect(Validators.isNumeric('123'), true);
        expect(Validators.isNumeric('123.45'), true);
        expect(Validators.isNumeric('-123'), true);
        expect(Validators.isNumeric('0'), true);
      });

      test('should return false for non-numeric strings', () {
        expect(Validators.isNumeric('abc'), false);
        expect(Validators.isNumeric('12a'), false);
        expect(Validators.isNumeric(''), false);
        expect(Validators.isNumeric('12.34.56'), false);
      });
    });

    group('isLengthValid', () {
      test('should validate string length correctly', () {
        expect(Validators.isLengthValid('test', 1, 10), true);
        expect(Validators.isLengthValid('test', 4, 4), true);
        expect(Validators.isLengthValid('test', 1), true); // no max length
      });

      test('should return false for invalid lengths', () {
        expect(Validators.isLengthValid('test', 5, 10), false); // too short
        expect(Validators.isLengthValid('test', 1, 3), false); // too long
        expect(Validators.isLengthValid('', 1, 10), false); // empty and min > 0
      });
    });
  });
}
