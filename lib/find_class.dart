import 'package:flutter/material.dart';

class FindClassPage extends StatefulWidget {
  const FindClassPage({super.key});

  @override
  State<FindClassPage> createState() => _FindClassPageState();
}

class _FindClassPageState extends State<FindClassPage> {
  final TextEditingController ipController = TextEditingController();
  String result = "";

  bool isValidIP(String ip) {
    List<String> parts = ip.split('.');
    if (parts.length != 4) return false;
    for (int i = 0; i < parts.length; i++) {
      int? number = int.tryParse(parts[i]);
      if (number == null || number < 0 || number > 255) return false;
      if (i == 0 && number == 0) return false;
    }
    return true;
  }

  void findClass() {
    String ip = ipController.text.trim();

    if (ip.isEmpty || !isValidIP(ip)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid IP Address")),
      );
      return;
    }

    List<String> parts = ip.split('.');
    int firstOctet = int.parse(parts[0]);
    String ipClass = "";
    String description = "";

    if (firstOctet >= 1 && firstOctet <= 126) {
      ipClass = "Class A";
      description = "Supports 16 million hosts. Used for huge networks.";
    } else if (firstOctet == 127) {
      ipClass = "Class A (Loopback)";
      description = "Reserved for loopback/localhost testing.";
    } else if (firstOctet >= 128 && firstOctet <= 191) {
      ipClass = "Class B";
      description = "Supports 65,000 hosts. Used for medium networks.";
    } else if (firstOctet >= 192 && firstOctet <= 223) {
      ipClass = "Class C";
      description = "Supports 254 hosts. Used for small/LAN networks.";
    } else if (firstOctet >= 224 && firstOctet <= 239) {
      ipClass = "Class D";
      description = "Reserved for Multicasting.";
    } else if (firstOctet >= 240 && firstOctet <= 255) {
      ipClass = "Class E";
      description = "Reserved for Experimental/R&D purposes.";
    } else {
      ipClass = "Unknown";
    }

    setState(() {
      result = "IP Address: $ip\n\nNetwork Class: $ipClass\n\n$description";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Find IP Class"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: ipController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Enter IP Address",
                        hintText: "e.g. 192.168.1.10",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: findClass,
                        child: const Text("Find Class"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (result.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}