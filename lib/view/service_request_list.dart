import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_provider.dart';

class ServiceRequestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Requests'),
      ),
      body: ListView.builder(
        itemCount: formProvider.serviceRequests.length,
        itemBuilder: (context, index) {
          final request = formProvider.serviceRequests[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(request['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${request['email']}'),
                  Text('Phone: ${request['phone']}'),
                  Text('Service Type: ${request['serviceType']}'),
                  Text('Description: ${request['description']}'),
                  if (request['date'] != null) Text('Date: ${request['date']}'),
                  if (request['time'] != null) Text('Time: ${request['time']}'),
                  if (request['latitude'] != null && request['longitude'] != null)
                    Text('Location: ${request['latitude']}, ${request['longitude']}'),
                  if (request['image'] != null) Image.file(request['image']),
                  Row(
                    children: [
                      Text('Status: '),
                      DropdownButton<String>(
                        value: request['status'],
                        items: [
                          DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(value: 'Approved', child: Text('Approved')),
                          DropdownMenuItem(value: 'Complete', child: Text('Complete')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            formProvider.updateStatus(index, value);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/editServiceRequest',
                    arguments: {
                      'index': index,
                      'requestData': request,
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
