import 'package:cockpit/app/cockpit/data/terminal/pty_terminal_gateway.dart';
import 'package:cockpit/app/cockpit/domain/contracts/terminal_gateway.dart';
import 'package:cockpit/app/cockpit/domain/contracts/terminal_gateway_factory.dart';

/// Cria um [PtyTerminalGateway] novo por terminal.
class PtyTerminalGatewayFactory implements TerminalGatewayFactory {
  const PtyTerminalGatewayFactory();

  @override
  TerminalGateway create() => PtyTerminalGateway();
}
