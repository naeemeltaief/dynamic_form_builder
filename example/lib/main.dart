import 'package:dynamic_form_builder/dynamic_form_builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyFormPage(),
    );
  }
}


class MyFormPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  MyFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: DynamicForm(
          formKey: _formKey,
          fieldValues: const {},
          fieldsToUse: [
            TextFieldBase(
              name: 'Name',
              isRequired: true,
              validators: [
                MaxLengthValidator(params: 10, errorMessage: 'Max 10 chars')
              ],
            ),
            DropdownFieldBase(
              name: 'Gender',
              options: ['Male', 'Female'],
            ),
            CheckboxFieldBase(
              name: 'Interests',
              options: ['Sports', 'Music', 'Travel'],
            ),
            RadioFieldBase(
              name: 'Marital Status',
              options: ['Single', 'Married'],
            ),
            DateFieldBase(
              name: 'Date of Birth',
              initialValue: DateTime(2000, 1, 1),
            ),
            FileFieldBase(
              name: 'Profile Picture',
              allowMultiple: false,
              pickImagesOnly: true,
            ),
          ],
          onChanged: (key, value) {
            // Handle field changes
          },
          onSubmit: () {
            // Handle form submission
          },
        ),
      ),
    );
  }
}
