import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../dynamic_form_builder.dart';

abstract class FormFieldBase {
  String get name;
  bool get isRequired;
  bool get isDisabled;
  dynamic get initialValue;
  List<ValidatorBase> get validators;
}

class TextFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final String initialValue;
  @override
  final List<ValidatorBase> validators;

  TextFieldBase({
    required this.name,
    this.isRequired = false,
    this.isDisabled = false,
    this.initialValue = '',
    this.validators = const [],
  });
}

class TextAreaFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final String initialValue;
  @override
  final List<ValidatorBase> validators;

  TextAreaFieldBase({
    required this.name,
    this.isRequired = false,
    this.isDisabled = false,
    this.initialValue = '',
    this.validators = const [],
  });
}

class NumberFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final num initialValue;
  @override
  final List<ValidatorBase> validators;

  NumberFieldBase({
    required this.name,
    this.isRequired = false,
    this.isDisabled = false,
    required this.initialValue,
    this.validators = const [],
  });
}

class DropdownFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final String initialValue;
  @override
  final List<ValidatorBase> validators;
  final List<String> options;

  DropdownFieldBase({
    required this.name,
    required this.options,
    this.isRequired = false,
    this.isDisabled = false,
    this.initialValue = '',
    this.validators = const [],
  });
}

class CheckboxFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final List<String> initialValue;
  @override
  final List<ValidatorBase> validators;
  final List<String> options;

  CheckboxFieldBase({
    required this.name,
    required this.options,
    this.isRequired = false,
    this.isDisabled = false,
    this.initialValue = const [],
    this.validators = const [],
  });
}

class RadioFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final String initialValue;
  @override
  final List<ValidatorBase> validators;
  final List<String> options;

  RadioFieldBase({
    required this.name,
    required this.options,
    this.isRequired = false,
    this.isDisabled = false,
    this.initialValue = '',
    this.validators = const [],
  });
}

class DateFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final DateTime initialValue;
  @override
  final List<ValidatorBase> validators;

  DateFieldBase({
    required this.name,
    this.isRequired = false,
    this.isDisabled = false,
    required this.initialValue,
    this.validators = const [],
  });
}

class TimeFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final TimeOfDay initialValue;
  @override
  final List<ValidatorBase> validators;

  TimeFieldBase({
    required this.name,
    this.isRequired = false,
    this.isDisabled = false,
    required this.initialValue,
    this.validators = const [],
  });
}

class FileFieldBase implements FormFieldBase {
  @override
  final String name;
  @override
  final bool isRequired;
  @override
  final bool isDisabled;
  @override
  final List<PlatformFile> initialValue;
  @override
  final List<ValidatorBase> validators;
  final bool allowMultiple;
  final bool pickImagesOnly;

  FileFieldBase({
    required this.name,
    this.isRequired = false,
    this.isDisabled = false,
    this.initialValue = const [],
    this.validators = const [],
    this.allowMultiple = false,
    this.pickImagesOnly = false,
  });
}
