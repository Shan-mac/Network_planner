import 'dart:math';
import 'package:flutter/material.dart';

class VlsmPage extends StatefulWidget {
  const VlsmPage({super.key});

  @override
  State<VlsmPage> createState() => _VlsmPageState();
}

class _VlsmPageState extends State<VlsmPage> {
  final TextEditingController baseIpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hostController = TextEditingController();

  List<Map<String, dynamic>> subnetInputs = [];
  List<Map<String, String>> results = [];

  void addSubnet() {
    String name = nameController.text.trim();
    int? hosts = int.tryParse(hostController.text);

    if (name.isEmpty || hosts == null || hosts <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid subnet name & hosts")),
      );
      return;
    }

    subnetInputs.add({
      "name": name,
      "hosts": hosts,
    });

    nameController.clear();
    hostController.clear();

    setState(() {});
  }

  void calculateVLSM() {
    results.clear();

    if (baseIpController.text.isEmpty || subnetInputs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter base IP & subnet details")),
      );
      return;
    }

    // Sorting

    subnetInputs.sort((a, b) => b["hosts"].compareTo(a["hosts"]));

    List<String> octets = baseIpController.text.split(".");
    int currentLastOctet = int.parse(octets[3]);

    for (var subnet in subnetInputs) {
      int hosts = subnet["hosts"];

      // Calculate block size
      int bits = 0;
      while ((pow(2, bits) - 2) < hosts) {
        bits++;
      }

      int blockSize = pow(2, bits).toInt();
      int usableHosts = blockSize - 2;

      int networkLast = currentLastOctet;
      int firstHostLast = networkLast + 1;
      int lastHostLast = networkLast + usableHosts;
      int broadcastLast = networkLast + blockSize - 1;

      results.add({
        "name": subnet["name"],
        "network":
            "${octets[0]}.${octets[1]}.${octets[2]}.$networkLast",
        "usable": usableHosts.toString(),
        "first":
            "${octets[0]}.${octets[1]}.${octets[2]}.$firstHostLast",
        "last":
            "${octets[0]}.${octets[1]}.${octets[2]}.$lastHostLast",
        "broadcast":
            "${octets[0]}.${octets[1]}.${octets[2]}.$broadcastLast",
      });

      currentLastOctet += blockSize;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VLSM Calculator"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Base IP
            TextField(
              controller: baseIpController,
              decoration: const InputDecoration(
                labelText: "Base Network Address",
                hintText: "e.g. 192.168.10.0",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Subnet input card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Subnet Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: hostController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Hosts Needed",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: addSubnet,
                        child: const Text("Add Subnet"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Added subnet list
            if (subnetInputs.isNotEmpty)
              Card(
                elevation: 3,
                child: Column(
                  children: subnetInputs.map((s) {
                    return ListTile(
                      title: Text(s["name"]),
                      trailing: Text("Hosts: ${s["hosts"]}"),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateVLSM,
                child: const Text("Calculate VLSM"),
              ),
            ),

            const SizedBox(height: 25),

            // Result Table
            if (results.isNotEmpty)
              Card(
                elevation: 5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Subnet Name")),
                      DataColumn(label: Text("Network")),
                      DataColumn(label: Text("Usable Hosts")),
                      DataColumn(label: Text("First ID")),
                      DataColumn(label: Text("Last ID")),
                      DataColumn(label: Text("Broadcast")),
                    ],
                    rows: results
                        .map(
                          (r) => DataRow(cells: [
                            DataCell(Text(r["name"]!)),
                            DataCell(Text(r["network"]!)),
                            DataCell(Text(r["usable"]!)),
                            DataCell(Text(r["first"]!)),
                            DataCell(Text(r["last"]!)),
                            DataCell(Text(r["broadcast"]!)),
                          ]),
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
