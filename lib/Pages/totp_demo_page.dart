import 'package:flutter/material.dart';
import 'package:auth_app/Components/auth_card.dart';
import 'package:auth_app/Models/account.dart';

class TOTPDemoPage extends StatelessWidget {
  const TOTPDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example TOTP cards
    final exampleCards = [
      TOTPCard(
        id: '1',
        accountName: 'Test your strength',
        issuer: 'Running Challenge',
        secret: 'JBSWY3DPEHPK3PXP', // Example secret
        digits: 6,
        period: 30,
        createdAt: DateTime.now(),
        color: '#8FD6D2', // Teal color like in the image
      ),
      TOTPCard(
        id: '2',
        accountName: 'user@example.com',
        issuer: 'Google',
        secret: 'JBSWY3DPEHPK3PXP',
        digits: 6,
        period: 30,
        createdAt: DateTime.now(),
        color: '#4285F4', // Google blue
      ),
      TOTPCard(
        id: '3',
        accountName: 'myaccount',
        issuer: 'GitHub',
        secret: 'JBSWY3DPEHPK3PXP',
        digits: 6,
        period: 30,
        createdAt: DateTime.now(),
        color: '#24292E', // GitHub dark
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TOTP Authenticator'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: exampleCards.length,
        itemBuilder: (context, index) {
          return AuthCard(totpCard: exampleCards[index]);
        },
      ),
    );
  }
}
