import 'dart:math';
import 'package:flutter/material.dart';

class StaticSubnetPage extends StatefulWidget {
  const StaticSubnetPage({super.key});

  @override
  State<StaticSubnetPage> createState() => _StaticSubnetPageState();
}

class _StaticSubnetPageState extends State<StaticSubnetPage> {
  final TextEditingController baseIpController = TextEditingController();
  final TextEditingController hostsController = TextEditingController();
  final TextEditingController subnetsController = TextEditingController();

  List<Map<String, String>> results = [];

  int ipToInt(String ip) {
    List<int> o = ip.split('.').map(int.parse).toList();
    return (o[0] * 16777216) + (o[1] * 65536) + (o[2] * 256) + o[3];
  }

  String intToIp(int ipInt) {
    int o1 = (ipInt ~/ 16777216) % 256;
    int o2 = (ipInt ~/ 65536) % 256;
    int o3 = (ipInt ~/ 256) % 256;
    int o4 = ipInt % 256;
    return '$o1.$o2.$o3.$o4';
  }

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

  void calculateSubnets() {
    String ip = baseIpController.text.trim();
    int? hosts = int.tryParse(hostsController.text.trim());
    int? numSubnets = int.tryParse(subnetsController.text.trim());

    if (!isValidIP(ip) || hosts == null || hosts <= 0 || numSubnets == null || numSubnets <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid inputs for all fields.")),
      );
      return;
    }

    int bits = 0;
    while ((pow(2, bits) - 2) < hosts) {
      bits++;
    }
    int blockSize = pow(2, bits).toInt();
    int usableHosts = blockSize - 2;

    int currentIpInt = ipToInt(ip);
    List<Map<String, String>> newResults = [];

    for (int i = 0; i < numSubnets; i++) {
      int networkInt = currentIpInt;
      int firstHostInt = networkInt + 1;
      int broadcastInt = networkInt + blockSize - 1;
      int lastHostInt = broadcastInt - 1;

      newResults.add({
        "name": "Subnet ${i + 1}",
        "network": intToIp(networkInt),
        "usable": usableHosts.toString(),
        "first": intToIp(firstHostInt),
        "last": intToIp(lastHostInt),
        "broadcast": intToIp(broadcastInt),
      });

      currentIpInt += blockSize;
    }

    setState(() {
      results = newResults;
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
        title: const Text("Static Subnet Calculation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: baseIpController,
                      decoration: const InputDecoration(
                        labelText: "Base Network Address",
                        hintText: "192.168.20.0",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: hostsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hosts per Subnet",
                        hintText: "15",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: subnetsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Subnets",
                        hintText: "12",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: calculateSubnets,
                        child: const Text("Calculate Subnets"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (results.isNotEmpty)
              Card(
                elevation: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Network Name")),
                      DataColumn(label: Text("Network Address")),
                      DataColumn(label: Text("Usable Hosts")),
                      DataColumn(label: Text("First ID")),
                      DataColumn(label: Text("Last ID")),
                      DataColumn(label: Text("Broadcast ID")),
                    ],
                    rows: results.map((r) => DataRow(cells: [
                      DataCell(Text(r["name"]!)),
                      DataCell(Text(r["network"]!)),
                      DataCell(Text(r["usable"]!)),
                      DataCell(Text(r["first"]!)),
                      DataCell(Text(r["last"]!)),
                      DataCell(Text(r["broadcast"]!)),
                    ])).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}