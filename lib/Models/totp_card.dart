import 'package:hive/hive.dart';

part 'totp_card.g.dart';

@HiveType(typeId: 0)
class TotpCard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String issuer;

  @HiveField(2)
  final String accountName;

  @HiveField(3)
  final String secret;

  @HiveField(4)
  final int digits;

  @HiveField(5)
  final int period;

  @HiveField(6)
  final String algorithm;

  @HiveField(7)
  final DateTime createdAt;

  TotpCard({
    required this.id,
    required this.issuer,
    required this.accountName,
    required this.secret,
    this.digits = 6,
    this.period = 30,
    this.algorithm = 'SHA1',
    required this.createdAt,
  });
}
