import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/farm_sprites.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/farm/pix.dart';

/// O visual fixo de cada agente do Gorila Squad na fazenda: chapéu e cor.
/// A cor tinge o corpo (e o chapéu, quando ele é dos tingíveis: gorro, boné,
/// fone). Quem não está aqui segue com o visual sorteado pelo id.
///
/// Para mexer: troque o chapéu (`null` = careca) ou a cor (ARGB) na tabela.
const squadLooks = <String, SquadLook>{
  'escanor': SquadLook(FarmHat.crown, 0xFFf5c542), // ouro
  'bulma': SquadLook(FarmHat.headphones, 0xFF2bb3a3), // verde-água
  'ippo': SquadLook(FarmHat.cap, 0xFF3b7dd8), // azul
  'levi': SquadLook(FarmHat.beanie, 0xFF4f5a70), // tinta
  'nezuko': SquadLook(FarmHat.flower, 0xFFf08cb0), // rosa
  'saitama': SquadLook(null, 0xFFf7dc6f), // manteiga
  'gon': SquadLook(FarmHat.sprout, 0xFF5fbf4a), // verde
  'uraraka': SquadLook(FarmHat.bow, 0xFFe8798f), // rosé
  'kurama': SquadLook(FarmHat.wizard, 0xFFf08a2c), // laranja
  'ryuk': SquadLook(FarmHat.leaf, 0xFF8a5cc7), // roxo
  'shikamaru': SquadLook(FarmHat.chef, 0xFFeadfc4), // creme
  'light': SquadLook(FarmHat.straw, 0xFFd63a3a), // vermelho
  'dazai': SquadLook(FarmHat.cap, 0xFF34508a), // marinho
  'naruhodo': SquadLook(FarmHat.beanie, 0xFF9cb38a), // sálvia
};

/// Quanto da cor do agente entra no corpo de argila (0 = argila, 1 = a cor).
const squadBodyTint = 0.6;

class SquadLook {
  const SquadLook(this.hat, this.color);

  final FarmHat? hat;
  final int color;

  int get body => mix(clay, color, squadBodyTint);
}

/// Nome do agente do squad que o loop é, pelo tipo do subagente ou pelo
/// título inteiro (`gorila-squad:escanor` também vale), ou `null`.
String? squadNameOf(FarmLoop l) {
  String key(String s) => s.split(':').last.trim().toLowerCase();
  for (final s in [?l.agentType, l.title]) {
    if (squadLooks.containsKey(key(s))) return key(s);
  }
  return null;
}

SquadLook? squadLookOf(FarmLoop l) => squadLooks[squadNameOf(l)];
