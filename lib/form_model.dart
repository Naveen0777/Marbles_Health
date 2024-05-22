import 'package:flutter/material.dart';

class FormComponent {
  String label;
  String infoText;
  bool required;
  bool readOnly;
  bool hidden;
  bool done;

  FormComponent({
    this.label = '',
    this.infoText = '',
    this.required = false,
    this.readOnly = false,
    this.hidden = false,
    this.done = false,
  });
}

class FormModel extends ChangeNotifier {
  List<FormComponent> components = [FormComponent()];

  void addComponent() {
    components.add(FormComponent());
    notifyListeners();
  }

  void removeComponent(int index) {
    if (components.length > 1) {
      components.removeAt(index);
      notifyListeners();
    }
  }

  void updateComponent(int index, String label, String infoText, bool required,
      bool readOnly, bool hidden) {
    components[index]
      ..label = label
      ..infoText = infoText
      ..required = required
      ..readOnly = readOnly
      ..hidden = hidden;
    notifyListeners();
  }

  void markAsDone(int index, bool done) {
    components[index].done = done;
    notifyListeners();
  }
}
