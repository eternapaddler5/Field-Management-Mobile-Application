import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'form_provider.dart';

class EditServiceRequestForm extends StatefulWidget {
  final int index;
  final Map<String, dynamic> requestData;

  EditServiceRequestForm({required this.index, required this.requestData});

  @override
  _EditServiceRequestFormState createState() => _EditServiceRequestFormState();
}

class _EditServiceRequestFormState extends State<EditServiceRequestForm> {
  late DateTime? _selectedDate;
  late TimeOfDay? _selectedTime;
  File? _image;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;
  String? _selectedServiceType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.requestData['name']);
    _emailController = TextEditingController(text: widget.requestData['email']);
    _phoneController = TextEditingController(text: widget.requestData['phone']);
    _descriptionController = TextEditingController(text: widget.requestData['description']);
    _selectedServiceType = widget.requestData['serviceType'];
    _selectedDate = widget.requestData['date'] != null ? DateFormat.yMd().parse(widget.requestData['date']) : null;
    _selectedTime = widget.requestData['time'] != null ? TimeOfDay(hour: int.parse(widget.requestData['time'].split(":")[0]), minute: int.parse(widget.requestData['time'].split(":")[1])) : null;
    _image = widget.requestData['image'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Service Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formProvider.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Service Type',
                  ),
                  value: _selectedServiceType,
                  items: [
                    DropdownMenuItem(value: 'consultation', child: Text('Consultation')),
                    DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                    DropdownMenuItem(value: 'repair', child: Text('Repair')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a service type';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'No date chosen!'
                        : 'Date: ${DateFormat.yMd().format(_selectedDate!)}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                ListTile(
                  title: Text(
                    _selectedTime == null
                        ? 'No time chosen!'
                        : 'Time: ${_selectedTime!.format(context)}',
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(_image!),
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: Icon(Icons.camera),
                  label: Text('Capture Image'),
                ),
                ListTile(
                  title: Text(
                    _currentPosition == null
                        ? 'No location chosen!'
                        : 'Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                  ),
                  trailing: Icon(Icons.location_on),
                  onTap: _getCurrentLocation,
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedData = {
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'serviceType': _selectedServiceType,
                      'description': _descriptionController.text,
                      'date': _selectedDate != null ? DateFormat.yMd().format(_selectedDate!) : null,
                      'time': _selectedTime != null ? _selectedTime!.format(context) : null,
                      'latitude': _currentPosition?.latitude,
                      'longitude': _currentPosition?.longitude,
                    };
                    formProvider.updateForm(widget.index, updatedData, _image);
                    Navigator.pop(context);
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
