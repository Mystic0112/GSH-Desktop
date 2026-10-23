import 'package:cockpit/app/cockpit/domain/contracts/terminal_gateway.dart';

/// Fábrica de PTYs — **um por terminal**. Contrato no domínio; impl em `data/`.
abstract class TerminalGatewayFactory {
  TerminalGateway create();
}
