import 'package:flutter/material.dart';

// Import pages
import 'cidr_page.dart';
import 'static_subnet_page.dart';
import 'vlsm_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Network Subnet Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOption = "Select Option";

  final List<String> options = [
    "Select Option",
    "CIDR Notation Calculation",
    "Static Subnet Calculation",
    "VLSM Calculation",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Subnet Planner"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // Image Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/10310/10310245.png',
                      height: 180,
                      width: 180,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      "Select a Network Calculation Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dropdown Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: selectedOption,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Choose Option",
                    ),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });

                      // Navigation logic
                      if (value == "CIDR Notation Calculation") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CidrPage(),
                          ),
                        );
                      } 
                      else if (value == "Static Subnet Calculation") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StaticSubnetPage(),
                          ),
                        );
                      } 
                      else if (value == "VLSM Calculation") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VlsmPage(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
