// core/enum/user_type_enum.dart

enum UserType {
  admin,
  customer;

  String get name {
    switch (this) {
      case UserType.admin:
        return 'أدمن';
      case UserType.customer:
        return 'عميل';
    }
  }

  String get dbValue {
    switch (this) {
      case UserType.admin:
        return 'admin';
      case UserType.customer:
        return 'user';
    }
  }
}