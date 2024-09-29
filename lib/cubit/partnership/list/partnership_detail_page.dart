import 'package:flutter/material.dart';
import 'package:medmap/cubit/partnership/list/partnership_list_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PartnershipDetailPage extends StatelessWidget {
  final PartnershipListModel item;

  PartnershipDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    // Format tanggal dan waktu
    final DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_Hm();
    return Scaffold(
      appBar: AppBar(
        title: Text('Partnership Request #${item.id}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requested Product: ${item.product.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Full Name: ${item.firstName} ${item.lastName}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Company Name: ${item.companyName}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Employees: ${item.totalEmployee.toString()}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: item.email,
                );
                if (await canLaunch(emailUri.toString())) {
                  await launch(emailUri.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not launch $emailUri'),
                    ),
                  );
                }
              },
              child: Text(
                'Email: ${item.email}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () async {
                final Uri whatsappUri = Uri(
                  scheme: 'https',
                  host: 'wa.me',
                  path: item.phone,
                );
                if (await canLaunch(whatsappUri.toString())) {
                  await launch(whatsappUri.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not launch $whatsappUri'),
                    ),
                  );
                }
              },
              child: Text(
                'Phone: ${item.phone}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'ZIP Code: ${item.zipCode}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Location: ${item.state.name}, ${item.country.name}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Datetime: ${dateFormat.format(item.updatedAt)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}