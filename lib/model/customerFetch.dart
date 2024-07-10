import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'insertuser.dart';
import 'customerDelete.dart';
import 'update_user.dart';
import 'modelCustomers.dart';

class CustomerCardScreen extends StatefulWidget {
  @override
  _CustomerCardScreenState createState() => _CustomerCardScreenState();
}

class _CustomerCardScreenState extends State<CustomerCardScreen> {
  late Future<List<ModelCustomers>> futureCustomers;

  Future<List<ModelCustomers>> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('http://172.20.10.4/fluttersql/find.php'));

      if (response.statusCode == 200) {
        return modelCustomersFromJson(response.body);
      } else {
        throw Exception('Failed to load customers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load customers. Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureCustomers = fetchCustomers();
  }

  void refreshCustomerList() {
    setState(() {
      futureCustomers = fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Cards'),
      ),
      body: FutureBuilder<List<ModelCustomers>>(
        future: futureCustomers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CustomerCard(
                  customer: snapshot.data![index],
                  refreshCustomerList: refreshCustomerList,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertDataPage(
                onDataInserted: () {
                  refreshCustomerList();
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final ModelCustomers customer;
  final VoidCallback refreshCustomerList;

  const CustomerCard({Key? key, required this.customer, required this.refreshCustomerList}) : super(key: key);

 

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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateDataPage(customer: customer),
                          ),
                        ).then((value) {
                          if (value == true) {
                            refreshCustomerList();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool? confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this customer?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          try {
                            builder: (context) => deleteCustomer(customer:customer.id),
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Customer deleted successfully')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete customer: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Email: ${customer.email}'),
            Text('Phone: ${customer.phone}'),
            Text('Address: ${customer.address}'),
            Text('User Type: ${customer.usertype}'),
          ],
        ),
      ),
    );
  }
}

List<ModelCustomers> modelCustomersFromJson(String str) => List<ModelCustomers>.from(json.decode(str).map((x) => ModelCustomers.fromJson(x)));
