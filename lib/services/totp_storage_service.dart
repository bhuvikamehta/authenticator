import 'package:hive/hive.dart';
import '../Models/totp_card.dart';

class TotpStorageService {
  static const String _boxName = 'totpCards';
  
  Box<TotpCard>? _boxInstance;
  
  // Initialize and open the box
  Future<Box<TotpCard>> _getBox() async {
    if (_boxInstance != null && _boxInstance!.isOpen) {
      return _boxInstance!;
    }
    _boxInstance = await Hive.openBox<TotpCard>(_boxName);
    return _boxInstance!;
  }

  // Add a new TOTP card
  Future<void> addTotpCard(TotpCard card) async {
    final box = await _getBox();
    await box.put(card.id, card);
  }

  // Get all TOTP cards
  Future<List<TotpCard>> getAllTotpCards() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Get a specific TOTP card by ID
  Future<TotpCard?> getTotpCard(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  // Update a TOTP card
  Future<void> updateTotpCard(TotpCard card) async {
    final box = await _getBox();
    await box.put(card.id, card);
  }

  // Delete a TOTP card
  Future<void> deleteTotpCard(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  // Delete all TOTP cards
  Future<void> deleteAllTotpCards() async {
    final box = await _getBox();
    await box.clear();
  }

  // Close the box
  Future<void> close() async {
    if (_boxInstance != null && _boxInstance!.isOpen) {
      await _boxInstance!.close();
      _boxInstance = null;
    }
  }
}
