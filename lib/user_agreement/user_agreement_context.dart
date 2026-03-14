import 'package:flutter/material.dart';

class UserAgreementContext {
  
  Column get() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Welcome to this software. Please read the following terms carefully before you begin using it:"),
        SizedBox(height: 16),

        Text(
          "1. License:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("You may only use this software in compliance with this agreement. This software is for personal learning and communication purposes only and may not be used for illegal or infringing activities."),
        SizedBox(height: 8),

        Text(
          "2. Data and Privacy:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("When calling third-party APIs or user-defined APIs, HTTP requests may contain necessary technical information (such as device identifiers, request headers, cookies, authentication tokens, etc.) and data you actively provide in the request (such as account, email, location, or other parameters). This information may involve privacy during transmission. We recommend that you:"),
        SizedBox(height: 4),

        Text("- Provide relevant data only when necessary;"),
        Text("- Avoid including sensitive information in requests;"),
        Text("- Use security protocols such as HTTPS to ensure encrypted data transmission"),
        Text("- When configuring custom APIs, ensure they are legal, compliant, and meet privacy protection requirements."),
        SizedBox(height: 8),

        Text(
          "3. Third-Party API Usage:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("This software obtains data by calling third-party APIs. You understand and agree that:"),
        SizedBox(height: 4),

        Text("- The data and services of third-party APIs are the responsibility of the respective providers, and this software is not responsible for their accuracy, legality, or availability."),
        Text("- When using third-party APIs, you must comply with the API provider's terms of service and privacy policy."),
        Text("- This software shall not be liable for any consequences arising from the interruption, change, or termination of third-party API services."),
        SizedBox(height: 8),

        Text(
          "4. User-Defined API Usage:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("This software allows users to configure and call custom APIs. You understand and agree that:"),
        SizedBox(height: 4),

        Text("- You are solely responsible for ensuring that the configured APIs are legal, compliant, and do not infringe upon the rights of others."),
        Text("- You shall bear all risks, losses, or legal liabilities arising from the use of custom APIs."),
        Text("- This software is not responsible for the content, stability, or security of user-defined APIs."),
        SizedBox(height: 8),

        Text(
          "5. User Responsibility:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("You shall ensure that you comply with relevant laws and regulations while using this software and shall not upload or disseminate illegal, infringing, or inappropriate content."),
        SizedBox(height: 8),

        Text(
          "6. Disclaimer:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("This software is provided \"as is\" and is not liable for any errors, data loss, or other losses that may occur during use."),
        SizedBox(height: 8),

        Text(
          "7. Agreement Changes:",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),

        Text("We reserve the right to modify this agreement as necessary. The modified agreement will be published and take effect in the updated version."),
        SizedBox(height: 16),

        Text("Clicking \"Agree\" indicates that you have read and accepted the above terms.")
      ],
    );
  }
}