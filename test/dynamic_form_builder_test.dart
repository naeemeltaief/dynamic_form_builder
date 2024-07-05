import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_form_builder/dynamic_form_builder.dart';

void main() {
  group('DynamicForm Widget Tests', () {
    testWidgets('DynamicForm renders correctly', (WidgetTester tester) async {
      // Create a GlobalKey for the FormBuilder
      final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

      // Define some field values and fields to use
      final Map<String, dynamic> fieldValues = {};
      final List<FormFieldBase> fieldsToUse = [
        TextFieldBase(
          name: 'Name',
          isRequired: true,
          validators: [
            MaxLengthValidator(params: 10, errorMessage: 'Max 10 characters')
          ],
        ),
        DropdownFieldBase(
          name: 'Gender',
          options: ['Male', 'Female'],
          isRequired: true,
          validators: [
            MinLengthValidator(params: 1, errorMessage: 'Please select a gender')
          ],
        ),
      ];

      // Build the DynamicForm widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DynamicForm(
            formKey: formKey,
            fieldValues: fieldValues,
            fieldsToUse: fieldsToUse,
            onChanged: (key, value) {
              // Handle field changes
            },
            onSubmit: () {
              // Handle form submission
            },
          ),
        ),
      ));

      // Verify the form fields are rendered using specific finders
      expect(find.byType(FormBuilderTextField), findsOneWidget);

      // Instead of directly looking for FormBuilderDropdown, find the DropdownButtonFormField inside the FormBuilderDropdown
      expect(find.byWidgetPredicate((widget) => widget is DropdownButtonFormField && widget.decoration.labelText == 'Gender'), findsOneWidget);

      // Verify the submit button is rendered
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Simulate entering text into the Name field
      await tester.enterText(find.byType(FormBuilderTextField).first, 'John Doe');
      await tester.pumpAndSettle(); // Wait for the widget tree to settle

      // Verify the text is entered
      expect(find.text('John Doe'), findsOneWidget);

      // Simulate selecting a value from the Gender dropdown
      await tester.tap(find.byWidgetPredicate((widget) => widget is DropdownButtonFormField && widget.decoration.labelText == 'Gender'));
      await tester.pumpAndSettle(); // Wait for the dropdown to open
      await tester.tap(find.text('Male').last);
      await tester.pumpAndSettle(); // Wait for the dropdown to close

      // Verify the dropdown value is selected
      expect(find.text('Male'), findsOneWidget);

      // Simulate form submission
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle(); // Wait for the submission to process

      // Verify the form is valid and the submission is handled
      expect(formKey.currentState?.validate(), isTrue);
    });
  });
}
