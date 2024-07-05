abstract class ValidatorBase {
  String get key;
  dynamic get params;
  String get errorMessage;
}

class MaxLengthValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final int params;
  @override
  final String errorMessage;

  MaxLengthValidator({
    required this.params,
    this.key = 'max',
    this.errorMessage = 'Maximum length exceeded',
  });
}

class MinLengthValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final int params;
  @override
  final String errorMessage;

  MinLengthValidator({
    required this.params,
    this.key = 'min',
    this.errorMessage = 'Minimum length required',
  });
}

class MaxValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final num params;
  @override
  final String errorMessage;

  MaxValidator({
    required this.params,
    this.key = 'max',
    this.errorMessage = 'Value exceeds maximum',
  });
}

class MinValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final num params;
  @override
  final String errorMessage;

  MinValidator({
    required this.params,
    this.key = 'min',
    this.errorMessage = 'Value below minimum',
  });
}

class DateMaxValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final DateTime params;
  @override
  final String errorMessage;

  DateMaxValidator({
    required this.params,
    this.key = 'max',
    this.errorMessage = 'Date exceeds maximum',
  });
}

class DateMinValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final DateTime params;
  @override
  final String errorMessage;

  DateMinValidator({
    required this.params,
    this.key = 'min',
    this.errorMessage = 'Date below minimum',
  });
}

class FileSizeValidator implements ValidatorBase {
  @override
  final String key;
  @override
  final int params;
  @override
  final String errorMessage;

  FileSizeValidator({
    required this.params,
    this.key = 'size',
    this.errorMessage = 'File size exceeds limit',
  });
}
