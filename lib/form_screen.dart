import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'form_model.dart';

class FormScreen extends StatelessWidget {
  final FormModel formModel = GetIt.instance<FormModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormModel>(
      create: (context) => formModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marbles Health Form'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                  onPressed: () {
                    _showFormData(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
        body: Consumer<FormModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: model.components.length,
                    itemBuilder: (context, index) {
                      return FormComponentWidget(index: index);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[500],
                    ),
                    onPressed: () {
                      formModel.addComponent();
                    },
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showFormData(BuildContext context) {
    final formModel = GetIt.instance<FormModel>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Form Data'),
          content: SingleChildScrollView(
            child: Column(
              children: formModel.components
                  .asMap()
                  .entries
                  .map((entry) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text('Form ${entry.key + 1}'),
                          subtitle: Text('Label: ${entry.value.label},\n'
                              'Info: ${entry.value.infoText},\n'
                              'Settings :\n'
                              'Required: ${entry.value.required} , Read Only: ${entry.value.readOnly} , Hidden: ${entry.value.hidden}'),
                        ),
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class FormComponentWidget extends StatefulWidget {
  final int index;

  FormComponentWidget({required this.index});

  @override
  _FormComponentWidgetState createState() => _FormComponentWidgetState();
}

class _FormComponentWidgetState extends State<FormComponentWidget> {
  late TextEditingController _labelController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    super.initState();
    final formModel = Provider.of<FormModel>(context, listen: false);
    final component = formModel.components[widget.index];

    _labelController = TextEditingController(text: component.label);
    _infoTextController = TextEditingController(text: component.infoText);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    final component = formModel.components[widget.index];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Label',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      formModel.updateComponent(
                        widget.index,
                        value,
                        component.infoText,
                        component.required,
                        component.readOnly,
                        component.hidden,
                      );
                    },
                    controller: _labelController,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Info-Text',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      formModel.updateComponent(
                        widget.index,
                        component.label,
                        value,
                        component.required,
                        component.readOnly,
                        component.hidden,
                      );
                    },
                    controller: _infoTextController,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: component.required,
                            onChanged: (bool? value) {
                              formModel.updateComponent(
                                widget.index,
                                component.label,
                                component.infoText,
                                value ?? false,
                                component.readOnly,
                                component.hidden,
                              );
                            },
                          ),
                          const Text('Required'),
                        ],
                      ),
                      const SizedBox(width: 12.0),
                      Row(
                        children: [
                          Checkbox(
                            value: component.readOnly,
                            onChanged: (bool? value) {
                              formModel.updateComponent(
                                widget.index,
                                component.label,
                                component.infoText,
                                component.required,
                                value ?? false,
                                component.hidden,
                              );
                            },
                          ),
                          const Text('Read Only'),
                        ],
                      ),
                      const SizedBox(width: 12.0),
                      Row(
                        children: [
                          Checkbox(
                            value: component.hidden,
                            onChanged: (bool? value) {
                              formModel.updateComponent(
                                widget.index,
                                component.label,
                                component.infoText,
                                component.required,
                                component.readOnly,
                                value ?? false,
                              );
                            },
                          ),
                          const Text('Hidden'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[500],
                        ),
                        onPressed: () {
                          formModel.markAsDone(widget.index, true);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          formModel.removeComponent(widget.index);
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (component.done)
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            bottom: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    formModel.markAsDone(widget.index, false);
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
