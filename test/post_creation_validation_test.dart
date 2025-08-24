import 'package:flutter_test/flutter_test.dart';
import 'package:yominero/core/posts/post_validation.dart';

void main() {
  group('PostCreationValidator.validateRequestBudget', () {
    test('accepts empty', () {
      expect(PostCreationValidator.validateRequestBudget(''), isNull);
    });
    test('rejects non numeric', () {
      expect(PostCreationValidator.validateRequestBudget('abc'), isNotNull);
    });
    test('rejects negative', () {
      expect(PostCreationValidator.validateRequestBudget('-5'), isNotNull);
    });
    test('accepts positive', () {
      expect(PostCreationValidator.validateRequestBudget('120.5'), isNull);
    });
  });

  group('PostCreationValidator.validateOfferPricing', () {
    test('empty both ok', () {
      expect(PostCreationValidator.validateOfferPricing('', ''), isNull);
    });
    test('invalid from', () {
      expect(PostCreationValidator.validateOfferPricing('x', ''), isNotNull);
    });
    test('invalid to', () {
      expect(PostCreationValidator.validateOfferPricing('', 'y'), isNotNull);
    });
    test('range reversed', () {
      expect(PostCreationValidator.validateOfferPricing('10', '5'), isNotNull);
    });
    test('valid range', () {
      expect(PostCreationValidator.validateOfferPricing('10', '50'), isNull);
    });
  });
}
