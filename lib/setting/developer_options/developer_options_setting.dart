import 'package:flutter/material.dart';

class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({super.key});

  @override
  State<StatefulWidget> createState() => DeveloperOptionsPageState();
}

class DeveloperOptionsPageState extends State<DeveloperOptionsPage> {
  late Future configLoadFuture;

  Future<bool> loadConfig() async {
    return true;
  }

  @override
  void initState() {
    super.initState();
  
    configLoadFuture = loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: configLoadFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("Developer Options")),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: [

                const Icon(
                  Icons.code,
                  size: 80,
                  color: Colors.teal,
                ),

                const SizedBox(height: 16),
                const Column(
                  children: [
                    Text("Used for testing or advanced control."),
                    Text("Some features require a restart to take effect.")
                  ],
                ),
                const SizedBox(height: 16),
                
                // TODO
              ],
            )
          );
        }
      }
    );
  }
}