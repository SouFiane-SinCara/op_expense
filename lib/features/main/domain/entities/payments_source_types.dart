enum PaymentsSourceTypes {
  creditCard,
  cash,
  bank,
  mobileWallet,
}

extension PaymentsSourceExtensions on PaymentsSourceTypes {
  List<String> get providersLogos {
    switch (this) {
      case PaymentsSourceTypes.creditCard:
        return [
          'lib/core/assets/images/setup_wallet/visa.png',
          'lib/core/assets/images/setup_wallet/mastercard.png',
          'lib/core/assets/images/setup_wallet/American_Express.png',
          'lib/core/assets/images/setup_wallet/Diners_Clubpng.png',
          'lib/core/assets/images/setup_wallet/Discover.png',
          'lib/core/assets/images/setup_wallet/UnionPay_logo.png',
        ];
      case PaymentsSourceTypes.bank:
        return [
          'lib/core/assets/images/setup_wallet/chase-bank.png',
          'lib/core/assets/images/setup_wallet/Bank-of-America-Emblem.png',
          'lib/core/assets/images/setup_wallet/Wells-Fargo-Emblem.png',
          'lib/core/assets/images/setup_wallet/Barclays-Logo.wine.png',
          'lib/core/assets/images/setup_wallet/bank-hsbc.png',
        ];
      case PaymentsSourceTypes.mobileWallet:
        return [
          'lib/core/assets/images/setup_wallet/gpaypng.png',
          'lib/core/assets/images/setup_wallet/Apple_Pay.png',
          'lib/core/assets/images/setup_wallet/Samsung-Pay.png',
          'lib/core/assets/images/setup_wallet/Paypal.png',
          'lib/core/assets/images/setup_wallet/alipay.png',
          'lib/core/assets/images/setup_wallet/Venmo_logo.png',
        ];
      case PaymentsSourceTypes.cash:
        return [];
      default:
        return [];
    }
  }
}

extension PaymentSourceTypesExtension on PaymentsSourceTypes {
  String get toShortString {
    switch (this) {
      case PaymentsSourceTypes.creditCard:
        return 'Credit Card';
      case PaymentsSourceTypes.cash:
        return 'Cash';
      case PaymentsSourceTypes.bank:
        return 'Bank';
      case PaymentsSourceTypes.mobileWallet:
        return 'Mobile Wallet';
      default:
        return 'Cash';
    }
  }
}

extension PaymentsSourceTypesExtension on String {
  PaymentsSourceTypes get toPaymentsSourceTypes {
    switch (this) {
      case 'creditCard':
        return PaymentsSourceTypes.creditCard;
      case 'cash':
        return PaymentsSourceTypes.cash;
      case 'bank':
        return PaymentsSourceTypes.bank;
      case 'mobileWallet':
        return PaymentsSourceTypes.mobileWallet;
      default:
        return PaymentsSourceTypes.cash;
    }
  }
}
