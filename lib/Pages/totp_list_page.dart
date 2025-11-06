import 'package:auth_app/services/totp_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:auth_app/Components/totp_card_widget.dart';
import 'package:auth_app/Models/totp_card.dart';


class TotpListPage extends StatefulWidget {
  const TotpListPage({super.key});

  @override
  State<TotpListPage> createState() => _TotpListPageState();
}

class _TotpListPageState extends State<TotpListPage> {
  final TotpStorageService _storage = TotpStorageService();
  List<TotpCard> _totpCards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTotpCards();
  }

  Future<void> _loadTotpCards() async {
    setState(() => _isLoading = true);
    final cards = await _storage.getAllTotpCards();
    setState(() {
      _totpCards = cards;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOTP Authenticator'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _totpCards.isEmpty
              ? const Center(
                  child: Text('No TOTP cards added yet'),
                )
              : ListView.builder(
                  itemCount: _totpCards.length,
                  itemBuilder: (context, index) {
                    return TotpCardWidget(
                      totpCard: _totpCards[index],
                      onDeleted: _loadTotpCards,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add TOTP page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
