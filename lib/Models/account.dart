class TOTPCard {
  final String id;
  final String accountName;
  final String issuer;       
  final String secret;
  final String algorithm;    
  final int digits;           
  final int period;          
  final DateTime createdAt;
  DateTime? lastUsed;
  bool favorite;
  String? color;
  String? icon;

  TOTPCard({
    required this.id,
    required this.accountName,
    required this.issuer,
    required this.secret,
    this.algorithm = "SHA1",
    this.digits = 6,
    this.period = 30,
    required this.createdAt,
    this.lastUsed,
    this.favorite = false,
    this.color,
    this.icon,
  });
}
