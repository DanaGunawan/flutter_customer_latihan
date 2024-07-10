import 'package:flutter/material.dart';
import 'insertuser.dart';
import 'modelCustomers.dart';
import 'update_user.dart';

class CustomerCard extends StatelessWidget {
  final ModelCustomers customer;
  final VoidCallback refreshCustomerList;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.refreshCustomerList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customer.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateDataPage(
                          customer: customer,
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        refreshCustomerList();  // Refresh the list on successful update
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Email: ${customer.email}'),
            Text('Phone: ${customer.phone}'),
            Text('Address: ${customer.address}'),
            Text('User Type: ${customer.usertype}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsertDataPage(
                      onDataInserted: refreshCustomerList,  // Pass the callback to InsertDataPage
                    ),
                  ),
                );
              },
              child: Text('Add New Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
