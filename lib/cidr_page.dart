import 'package:flutter/material.dart';

class CidrPage extends StatefulWidget {
  const CidrPage({super.key});

  @override
  State<CidrPage> createState() => _CidrPageState();
}

class _CidrPageState extends State<CidrPage> {
  TextEditingController ipController = TextEditingController();
  TextEditingController cidrController = TextEditingController();

  String result = "";

  List<int> ipToList(String ip) {
    return ip.split('.').map(int.parse).toList();
  }

  String listToIp(List<int> list) {
    return list.join('.');
  }

  List<int> cidrToSubnetMask(int cidr) {
    List<int> mask = [0, 0, 0, 0];
    for (int i = 0; i < 4; i++) {
      if (cidr >= 8) {
        mask[i] = 255;
        cidr -= 8;
      } else if (cidr > 0) {
        mask[i] = 256 - (1 << (8 - cidr));
        cidr = 0;
      }
    }
    return mask;
  }

  List<int> calculateNetwork(List<int> ip, List<int> mask) {
    return List.generate(4, (i) => ip[i] & mask[i]);
  }

  List<int> calculateBroadcast(List<int> network, List<int> mask) {
    return List.generate(4, (i) => network[i] | (255 - mask[i]));
  }

  int totalHosts(int cidr) => 1 << (32 - cidr);

  int usableHosts(int cidr) {
    if (cidr >= 31) return 0;
    return (1 << (32 - cidr)) - 2;
  }


  // Validation Logic
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

  // Main Calculation
  void calculateCidr() {

    // Validate the IP address
    if (ipController.text.isEmpty || !isValidIP(ipController.text)) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid IP (e.g. 192.168.1.1)")),
      );
      return;
    }

    if (cidrController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter CIDR")),
      );
      return;
    }

    int cidr = int.parse(cidrController.text);
    if (cidr < 0 || cidr > 32) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CIDR must be between 0 and 32")),
      );
      return;
    }

    List<int> ip = ipToList(ipController.text);
    List<int> mask = cidrToSubnetMask(cidr);
    List<int> network = calculateNetwork(ip, mask);
    List<int> broadcast = calculateBroadcast(network, mask);

    setState(() {
      result =
          """
Subnet Mask   : ${listToIp(mask)}
Network Addr  : ${listToIp(network)}
Broadcast     : ${listToIp(broadcast)}
Total Hosts   : ${totalHosts(cidr)}
Usable Hosts  : ${usableHosts(cidr)}
""";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CIDR Notation Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: ipController,
                      decoration: const InputDecoration(
                        labelText: "IP Address (e.g. 192.168.1.10)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: cidrController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "CIDR Value (e.g. 24)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: calculateCidr,
                      child: const Text("Calculate"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.blue.shade50,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  result.isEmpty ? "Result will appear here" : result,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
