import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiCheckButton extends StatefulWidget {
  final String api;
  const ApiCheckButton({required this.api, super.key});

  @override
  State<ApiCheckButton> createState() => ApiCheckButtonState();
}

class ApiCheckButtonState extends State<ApiCheckButton> {
  bool checking = false;
  bool? success;

  Future<bool> checkApiConnectivity(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _check() async {
    setState(() => checking = true);
    final ok = await checkApiConnectivity(widget.api);

    if (!mounted) return;

    setState(() {
      checking = false;
      success = ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget icon;
    if (checking) {
      icon = const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (success == true) {
      icon = const Icon(Icons.check, color: Colors.green);
    } else if (success == false) {
      icon = const Icon(Icons.close, color: Colors.red);
    } else {
      icon = Icon(Icons.network_ping, color: Theme.of(context).colorScheme.primary);
    }

    return IconButton(icon: icon, onPressed: checking ? null : _check);
  }
}