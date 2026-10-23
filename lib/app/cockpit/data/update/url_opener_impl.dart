import 'package:cockpit/app/cockpit/domain/contracts/url_opener.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre URLs externas via `url_launcher` (navegador/handler do SO).
class UrlOpenerImpl implements UrlOpener {
  const UrlOpenerImpl();

  @override
  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
