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
  
  void clearList() {
    setState(() {
      subnetInputs.clear();
      results.clear();
      baseIpController.clear();
    });
  }

  void calculateVLSM() {
    results.clear();

    if (!isValidIP(baseIpController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Base IP Address")),
      );
      return;
    }

    if (baseIpController.text.isEmpty || subnetInputs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter base IP & subnet details")),
      );
      return;
    }

    subnetInputs.sort((a, b) => b["hosts"].compareTo(a["hosts"]));

    int currentIpInt = ipToInt(baseIpController.text.trim());

    for (var subnet in subnetInputs) {
      int hosts = subnet["hosts"];

      int bits = 0;
      while ((pow(2, bits) - 2) < hosts) {
        bits++;
      }

      int blockSize = pow(2, bits).toInt();
      int usableHosts = blockSize - 2;

      int networkInt = currentIpInt;
      int firstHostInt = networkInt + 1;
      int broadcastInt = networkInt + blockSize - 1;
      int lastHostInt = broadcastInt - 1;

      results.add({
        "name": subnet["name"],
        "network": intToIp(networkInt),
        "usable": usableHosts.toString(),
        "first": intToIp(firstHostInt),
        "last": intToIp(lastHostInt),
        "broadcast": intToIp(broadcastInt),
      });

      currentIpInt += blockSize;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("VLSM Calculation"),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Subnet Name",
                              hintText: "e.g. HR Dept",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: hostController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Hosts",
                              hintText: "60",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: addSubnet,
                        child: const Text("Add Subnet to List"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (subnetInputs.isNotEmpty)
              Card(
                elevation: 2,
                color: Colors.blue.shade50,
                child: Column(
                  children: subnetInputs.map((s) {
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.lan, color: Colors.blue),
                      title: Text(s["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text("${s["hosts"]} Hosts required"),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: clearList,
                    child: const Text("Clear Data"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: calculateVLSM,
                    child: const Text("Calculate VLSM"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
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