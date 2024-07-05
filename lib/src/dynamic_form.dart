import 'package:dynamic_form_builder/dynamic_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DynamicForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List<FormFieldBase>? fieldsToUse;
  final Map<String, dynamic> fieldValues;
  final Function(String key, dynamic value)? onChanged;
  final VoidCallback? onSubmit;

  const DynamicForm({
    super.key,
    required this.formKey,
    required this.fieldValues,
    this.onChanged,
    this.fieldsToUse,
    this.onSubmit,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  void initState() {
    super.initState();
    _updateFormFields();
  }

  @override
  void dispose() {
    widget.formKey.currentState?.fields.forEach((key, field) {
      field.dispose();
    });
    super.dispose();
  }

  void _updateFormFields() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.formKey.currentState != null) {
        widget.formKey.currentState?.fields.forEach((key, field) {
          if (field.value != null) {
            field.didChange(field.value);
          }
        });
      }
    });
  }

  bool get isFormValidAndTouched {
    final formState = widget.formKey.currentState;
    if (formState == null) return false;

    formState.save();
    bool isValid = formState.validate();

    bool isAnyFieldTouchedOrHasInitial = widget.fieldsToUse?.any((field) {
          var fieldValue = formState.fields[field.name]?.value;
          var fieldInitial = widget.fieldValues[field.name];
          bool isTouched = formState.fields[field.name]?.isTouched ?? false;
          return isTouched ||
              (fieldValue != null && fieldValue != fieldInitial);
        }) ??
        false;

    return isValid && isAnyFieldTouchedOrHasInitial;
  }

  List<String? Function(dynamic)> _buildValidators(FormFieldBase field) {
    List<String? Function(dynamic)> formValidators = [];

    if (field.isRequired) {
      formValidators.add(
          FormBuilderValidators.required(errorText: "${field.name} مطلوب"));
    }

    for (var validator in field.validators) {
      switch (validator.key) {
        case 'max':
          if (field is TextFieldBase || field is TextAreaFieldBase) {
            int? maxLength = validator.params;
            if (maxLength != null) {
              formValidators.add((value) {
                if (value == null) return null;
                if (value.toString().length > maxLength) {
                  return "${validator.errorMessage} ${validator.params}";
                }
                return null;
              });
            }
          } else if (field is NumberFieldBase) {
            num? maxNum = validator.params;
            if (maxNum != null) {
              formValidators.add(FormBuilderValidators.max(maxNum,
                  errorText: "${validator.errorMessage} ${validator.params}"));
            }
          } else if (field is DateFieldBase) {
            DateTime? maxDate = validator.params;
            if (maxDate != null) {
              formValidators.add((dynamic value) {
                DateTime? inputDate = value is DateTime
                    ? value
                    : DateTime.tryParse(value?.toString() ?? '');
                if (inputDate != null && inputDate.isAfter(maxDate)) {
                  return "${validator.errorMessage} ${DateFormat('yyyy-MM-dd').format(maxDate)}";
                }
                return null;
              });
            }
          }
          break;
        case 'min':
          if (field is TextFieldBase || field is TextAreaFieldBase) {
            int? minLength = validator.params;
            if (minLength != null) {
              formValidators.add((value) {
                if (value == null) return null;
                if (value.toString().length < minLength) {
                  return "${validator.errorMessage} ${validator.params}";
                }
                return null;
              });
            }
          } else if (field is NumberFieldBase) {
            num? minNum = validator.params;
            if (minNum != null) {
              formValidators.add(FormBuilderValidators.min(minNum,
                  errorText: "${validator.errorMessage} ${validator.params}"));
            }
          } else if (field is DateFieldBase) {
            DateTime? minDate = validator.params;
            if (minDate != null) {
              formValidators.add((dynamic value) {
                DateTime? inputDate = value is DateTime
                    ? value
                    : DateTime.tryParse(value?.toString() ?? '');
                if (inputDate != null && inputDate.isBefore(minDate)) {
                  return "${validator.errorMessage} ${DateFormat('yyyy-MM-dd').format(minDate)}";
                }
                return null;
              });
            }
          }
          break;
        case 'size':
          if (field is FileFieldBase) {
            int? maxSize = validator.params;
            if (maxSize != null) {
              formValidators.add((dynamic value) {
                List<PlatformFile>? files = value;
                if (files != null && files.isNotEmpty) {
                  int totalSize = files.fold(
                      0, (previousValue, file) => previousValue + file.size);
                  if (totalSize > maxSize) {
                    return "${validator.errorMessage} ${validator.params}";
                  }
                }
                return null;
              });
            }
          }
          break;
      }
    }

    return formValidators;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgets = widget.fieldsToUse
            ?.map((field) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildFormField(context, field),
                ))
            .toList() ??
        [];

    if (widget.onSubmit != null) {
      formWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (isFormValidAndTouched) {
                widget.onSubmit!();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill the required fields')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ),
      );
    }

    return FormBuilder(
      key: widget.formKey,
      child: Column(children: formWidgets),
    );
  }

  Widget _buildFormField(BuildContext context, FormFieldBase field) {
    switch (field.runtimeType) {
      case const (TextFieldBase):
        final textField = field as TextFieldBase;
        return FormBuilderTextField(
          name: textField.name,
          initialValue: widget.fieldValues[textField.name],
          enabled: !textField.isDisabled,
          decoration: InputDecoration(
            labelText: textField.name,
            hintText: textField.name,
          ),
          validator: FormBuilderValidators.compose(_buildValidators(textField)),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(textField.name, value);
            }
          },
        );
      case const (DropdownFieldBase):
        final dropdownField = field as DropdownFieldBase;
        return FormBuilderDropdown(
          name: dropdownField.name,
          initialValue: widget.fieldValues[dropdownField.name],
          enabled: !dropdownField.isDisabled,
          decoration: InputDecoration(
            labelText: dropdownField.name,
            hintText: dropdownField.name,
          ),
          validator:
              FormBuilderValidators.compose(_buildValidators(dropdownField)),
          items: dropdownField.options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(dropdownField.name, value);
            }
          },
        );
      case const (CheckboxFieldBase):
        final checkboxField = field as CheckboxFieldBase;
        return FormBuilderCheckboxGroup(
          name: checkboxField.name,
          initialValue: widget.fieldValues[checkboxField.name],
          enabled: !checkboxField.isDisabled,
          decoration: InputDecoration(
            labelText: checkboxField.name,
            hintText: checkboxField.name,
          ),
          validator:
              FormBuilderValidators.compose(_buildValidators(checkboxField)),
          options: checkboxField.options.map((option) {
            return FormBuilderFieldOption(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(checkboxField.name, value);
            }
          },
        );
      case const (RadioFieldBase):
        final radioField = field as RadioFieldBase;
        return FormBuilderRadioGroup(
          name: radioField.name,
          initialValue: widget.fieldValues[radioField.name],
          enabled: !radioField.isDisabled,
          decoration: InputDecoration(
            labelText: radioField.name,
            hintText: radioField.name,
          ),
          validator:
              FormBuilderValidators.compose(_buildValidators(radioField)),
          options: radioField.options.map((option) {
            return FormBuilderFieldOption(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(radioField.name, value);
            }
          },
        );
      case const (DateFieldBase):
        final dateField = field as DateFieldBase;
        return FormBuilderDateTimePicker(
          name: dateField.name,
          initialValue: widget.fieldValues[dateField.name],
          enabled: !dateField.isDisabled,
          decoration: InputDecoration(
            labelText: dateField.name,
            hintText: dateField.name,
          ),
          validator: FormBuilderValidators.compose(_buildValidators(dateField)),
          inputType: InputType.date,
          format: DateFormat('yyyy-MM-dd'),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(dateField.name, value);
            }
          },
        );
      case const (TimeFieldBase):
        final timeField = field as TimeFieldBase;
        return FormBuilderDateTimePicker(
          name: timeField.name,
          initialValue: widget.fieldValues[timeField.name],
          enabled: !timeField.isDisabled,
          decoration: InputDecoration(
            labelText: timeField.name,
            hintText: timeField.name,
          ),
          validator: FormBuilderValidators.compose(_buildValidators(timeField)),
          inputType: InputType.time,
          format: DateFormat('HH:mm'),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(timeField.name, value);
            }
          },
        );
      case const (NumberFieldBase):
        final numberField = field as NumberFieldBase;
        return FormBuilderTextField(
          name: numberField.name,
          initialValue: widget.fieldValues[numberField.name],
          enabled: !numberField.isDisabled,
          decoration: InputDecoration(
            labelText: numberField.name,
            hintText: numberField.name,
          ),
          validator:
              FormBuilderValidators.compose(_buildValidators(numberField)),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(numberField.name, value);
            }
          },
        );
      case const (FileFieldBase):
        final fileField = field as FileFieldBase;
        return FormBuilderField<List<PlatformFile>>(
          name: fileField.name,
          enabled: !fileField.isDisabled,
          initialValue: widget.fieldValues[fileField.name],
          validator: FormBuilderValidators.compose(_buildValidators(fileField)),
          builder: (FormFieldState<List<PlatformFile>> fieldState) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: fileField.name,
                hintText: fileField.name,
                errorText: fieldState.errorText,
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: fileField.isDisabled
                        ? null
                        : () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    allowMultiple: fileField.allowMultiple,
                                    type: fileField.pickImagesOnly
                                        ? FileType.image
                                        : FileType.any);
                            if (result != null) {
                              List<PlatformFile> files = result.files;
                              fieldState.didChange(files);
                              if (widget.onChanged != null) {
                                widget.onChanged!(
                                    fileField.name,
                                    fileField.allowMultiple
                                        ? files
                                        : files.first);
                              }
                            }
                          },
                    child: Text(
                        fileField.isDisabled ? 'File Uploaded' : 'Pick File'),
                  ),
                  if (fieldState.value != null)
                    ...fieldState.value!.map((file) {
                      return Text(file.name);
                    }),
                ],
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
