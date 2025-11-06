import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auth_app/Models/account.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharePage extends StatefulWidget {
  final List<TOTPCard> totpCards;
  
  const SharePage({super.key, required this.totpCards});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  String _generateTotpUri(TOTPCard card) {
    return 'otpauth://totp/${Uri.encodeComponent(card.issuer)}:${Uri.encodeComponent(card.accountName)}?secret=${card.secret}&issuer=${Uri.encodeComponent(card.issuer)}&digits=${card.digits}&period=${card.period}';
  }

  String _generateCombinedData() {
    if (widget.totpCards.isEmpty) return '';
    
    final allLinks = widget.totpCards.map((card) {
      return _generateTotpUri(card);
    }).join('\n');
    
    return allLinks;
  }

  void _copyToClipboard(String uri) {
    Clipboard.setData(ClipboardData(text: uri));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('TOTP link copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareAllLinks() {
    if (widget.totpCards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No TOTP cards to share'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final allLinks = widget.totpCards.map((card) {
      return '${card.issuer} (${card.accountName}):\n${_generateTotpUri(card)}';
    }).join('\n\n---\n\n');

    Clipboard.setData(ClipboardData(text: allLinks));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All TOTP links copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final elevatedButtonStyle = theme.elevatedButtonTheme.style;
    final buttonBackgroundColor =
        elevatedButtonStyle?.backgroundColor?.resolve({}) ?? theme.primaryColor;
    final buttonForegroundColor =
        elevatedButtonStyle?.foregroundColor?.resolve({}) ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share TOTP Links'),
        backgroundColor: buttonBackgroundColor,
        foregroundColor: buttonForegroundColor,
        actions: [
          if (widget.totpCards.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy_all),
              onPressed: _shareAllLinks,
              tooltip: 'Copy All',
            ),
        ],
      ),
      body: widget.totpCards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No TOTP cards to share',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Combined QR Code
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Scan to Import All Accounts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          QrImageView(
                            data: _generateCombinedData(),
                            version: QrVersions.auto,
                            size: 280.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${widget.totpCards.length} account(s)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Individual Accounts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.totpCards.length,
                    itemBuilder: (context, index) {
                      final card = widget.totpCards[index];
                      final uri = _generateTotpUri(card);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: buttonBackgroundColor,
                            child: Icon(
                              Icons.vpn_key,
                              color: buttonForegroundColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            card.issuer,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            card.accountName,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TOTP Link:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: SelectableText(
                                      uri,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () => _copyToClipboard(uri),
                                        icon: const Icon(Icons.copy, size: 18),
                                        label: const Text('Copy'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: buttonBackgroundColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: () => _copyToClipboard(uri),
                                        icon: const Icon(Icons.copy_all, size: 18),
                                        label: const Text('Copy Link'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonBackgroundColor,
                                          foregroundColor: buttonForegroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
