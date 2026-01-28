import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedOption;

  final Map<String, String> optionDescriptions = {
    'CIDR Calculator':
        'Calculate subnet mask, network address, broadcast address and usable hosts using CIDR notation.',
    'Static Subnet Calculator':
        'Divide a network into equal-sized subnets and calculate address ranges.',
    'VLSM Planner':
        'Design networks with different host requirements using Variable Length Subnet Masking.',
    'IP Class Finder': 'Identify IP address class and default subnet mask.',
    'Saved Network Designs': 'View and manage previously saved subnet plans.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Network Subnet Planner",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.network_check),
        backgroundColor: Colors.blue.shade700,
        elevation: 6,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              // image card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ), // less space outside
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // reduced from 16 to 8
                  child: Center(
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/10310/10310245.png',
                      height: 180, // slightly smaller height
                      width: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15), // reduced spacing after the card
              // Title Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Select Calculation Type",
                      style: const TextStyle(
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
                color: Colors.grey.shade100,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Calculation Type",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedOption,
                    items: optionDescriptions.keys.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Description Card
              if (selectedOption != null)
                Card(
                  color: Colors.blue.shade50,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.description_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            optionDescriptions[selectedOption]!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Continue Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedOption == null
                      ? null
                      : () {
                          // For now, just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$selectedOption selected (navigation not implemented yet)',
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
