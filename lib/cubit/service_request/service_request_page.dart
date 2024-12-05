import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_request_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../../views/service_request.dart' as listServiceRequest;

class ServiceRequestPage extends StatelessWidget {
  final int itemId;

  ServiceRequestPage({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceRequestCubit(),
      child: ServiceRequestForm(itemId: itemId),
    );
  }
}

class ServiceRequestForm extends StatefulWidget {
  final int itemId;

  ServiceRequestForm({Key? key, required this.itemId}) : super(key: key);

  @override
  _ServiceRequestFormState createState() => _ServiceRequestFormState();
}

class _ServiceRequestFormState extends State<ServiceRequestForm> {
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final imageEmbed = BlockEmbed.image(file.path);
      final index = _editorController.selection.baseOffset;
      final length = _editorController.selection.extentOffset - index;
      _editorController.replaceText(index, length, imageEmbed);
      setState(() {
        _images.add(file);
      });
    }
  }

  Widget _buildImageEmbed(BuildContext context, EmbedNode node) {
    if (node.value.type == 'image') {
      final data = node.value.data;
      String? imageUrl;
      imageUrl = data['source'] as String?;
      if (imageUrl != null) {
        return Image.file(File(imageUrl));
      } else {
        return Text('Invalid image data');
      }
    }
    return Text('Unsupported embed type: ${node.value.type}');
  }

  final _formKey = GlobalKey<FormState>();
  String? _selectedCurrency;
  String? _selectedPriceType;
  String _requestTitle = '';
  String _estimateBudget = '';
  late FleatherController _editorController;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _editorController = FleatherController();
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Request'),
      ),
      body: BlocListener<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {
          if (state is ServiceRequestLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Request Submitted Successfully')),
            );
            // context.pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => listServiceRequest.ServiceRequest(),
              ),
            );
          } else if (state is ServiceRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Request Title'),
                    onChanged: (value) => _requestTitle = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  FleatherToolbar.basic(controller: _editorController),
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: FleatherEditor(
                      controller: _editorController,
                      focusNode: FocusNode(),
                      embedBuilder: _buildImageEmbed,
                    ),
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Full Description'),
                  //   maxLines: 5,
                  //   onChanged: (value) => _fullDescription = value,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter a description';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    decoration: InputDecoration(labelText: 'Currency'),
                    items: <String>['USD', 'EUR', 'GBP', 'IDR', 'SGD', 'CNY']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a currency';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Estimate Budget'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _estimateBudget = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an estimate budget';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Price Type'),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: 'hourly',
                        groupValue: _selectedPriceType,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPriceType = value;
                          });
                        },
                      ),
                      Text('Hourly'),
                      Radio<String>(
                        value: 'fixed',
                        groupValue: _selectedPriceType,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPriceType = value;
                          });
                        },
                      ),
                      Text('Fixed'),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // navigate to service request details
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ServiceRequestDetails(
                      //       fullDescription: jsonEncode(
                      //           _editorController.document.toDelta().toJson()),
                      //     ),
                      //   ),
                      // );
                      if (_formKey.currentState!.validate()) {
                        context.read<ServiceRequestCubit>().submitRequest(
                              requestTitle: _requestTitle,
                              fullDescription: jsonEncode(_editorController
                                  .document
                                  .toDelta()
                                  .toJson()),
                              selectedCurrency: _selectedCurrency!,
                              estimateBudget: _estimateBudget,
                              selectedPriceType: _selectedPriceType!,
                              images: _images,
                            );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
