import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart'; 
import 'login_page.dart';
import 'find_class.dart';
import 'cidr_page.dart';
import 'vlsm_page.dart';
import 'static_subnet_page.dart'; 
class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});


  void logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = supabase.auth.currentUser?.email ?? '';
    final username = userEmail.replaceAll('@netcalc.local', '');

    return Scaffold(
      appBar: AppBar(
        title: const Text("NetCalc Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
            tooltip: "Logout",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.account_tree, size: 90, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome back, $username!",
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Select a networking tool to get started.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          
            Expanded(
              child: ListView(
                children: [
                  _buildMenuCard(
                    context, 
                    "IP Class Finder", 
                    "Identify Class A, B, C, D, E networks", 
                    Icons.class_, 
                    const FindClassPage()
                  ),
                  _buildMenuCard(
                    context, 
                    "Static Subnetting", 
                    "Divide a network into equal-sized subnets", 
                    Icons.grid_view, 
                    const StaticSubnetPage()
                  ),
                  _buildMenuCard(
                    context, 
                    "CIDR Calculator", 
                    "Calculate subnets using CIDR notation", 
                    Icons.calculate, 
                    const CidrPage()
                  ),
                  _buildMenuCard(
                    context, 
                    "VLSM Planner", 
                    "Advanced Variable Length Subnet Masking", 
                    Icons.lan, 
                    const VlsmPage()
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, IconData icon, Widget destinationPage) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue.shade50,
                child: Icon(icon, color: Colors.blueAccent, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}