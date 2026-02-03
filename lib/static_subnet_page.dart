import 'dart:math';
import 'package:flutter/material.dart';

class StaticSubnetPage extends StatefulWidget {
  const StaticSubnetPage({super.key});

  @override
  State<StaticSubnetPage> createState() => _StaticSubnetPageState();
}

class _StaticSubnetPageState extends State<StaticSubnetPage> {
  final TextEditingController networkController = TextEditingController();
  final TextEditingController hostController = TextEditingController();
  final TextEditingController subnetCountController = TextEditingController();

  List<Map<String, String>> subnetResults = [];

  void calculateSubnets() {
    subnetResults.clear();

    String baseIp = networkController.text.trim();
    int? requiredHosts = int.tryParse(hostController.text);
    int? subnetCount = int.tryParse(subnetCountController.text);

    if (baseIp.isEmpty ||
        requiredHosts == null ||
        subnetCount == null ||
        requiredHosts <= 0 ||
        subnetCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid inputs")),
      );
      return;
    }

    // Calculate block size
    int bits = 0;
    while ((pow(2, bits) - 2) < requiredHosts) {
      bits++;
    }

    int blockSize = pow(2, bits).toInt();
    int usableHosts = blockSize - 2;

    // Split base IP
    List<String> octets = baseIp.split(".");
    int baseLastOctet = int.parse(octets[3]);

    for (int i = 0; i < subnetCount; i++) {
      int networkLast = baseLastOctet + (blockSize * i);
      int firstHostLast = networkLast + 1;
      int lastHostLast = networkLast + usableHosts;
      int broadcastLast = networkLast + blockSize - 1;

      subnetResults.add({
        "name": "Subnet ${i + 1}",
        "network": "${octets[0]}.${octets[1]}.${octets[2]}.$networkLast",
        "usable": usableHosts.toString(),
        "first": "${octets[0]}.${octets[1]}.${octets[2]}.$firstHostLast",
        "last": "${octets[0]}.${octets[1]}.${octets[2]}.$lastHostLast",
        "broadcast":
            "${octets[0]}.${octets[1]}.${octets[2]}.$broadcastLast",
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Static Subnet Calculation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Input Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: networkController,
                      decoration: const InputDecoration(
                        labelText: "Base Network Address",
                        hintText: "e.g. 192.168.1.0",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: hostController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hosts per Subnet",
                        hintText: "e.g. 50",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: subnetCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Subnets",
                        hintText: "e.g. 5",
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

            const SizedBox(height: 25),

            // Result Table
            if (subnetResults.isNotEmpty)
              Card(
                elevation: 5,
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
                    rows: subnetResults
                        .map(
                          (subnet) => DataRow(
                            cells: [
                              DataCell(Text(subnet["name"]!)),
                              DataCell(Text(subnet["network"]!)),
                              DataCell(Text(subnet["usable"]!)),
                              DataCell(Text(subnet["first"]!)),
                              DataCell(Text(subnet["last"]!)),
                              DataCell(Text(subnet["broadcast"]!)),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
