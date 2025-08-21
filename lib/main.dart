import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// === CONTACTO (centralizado) ===
const String kPhoneE164 = '+525541829362'; // +52 5541829362
final Uri kWhatsAppUri = Uri.parse('https://wa.me/525541829362');
final Uri kTelUri = Uri.parse('tel:$kPhoneE164');

void main() {
  runApp(const DragonesApp());
}

double _clamp(double v, double min, double max) =>
    v < min ? min : (v > max ? max : v);

class DragonesApp extends StatelessWidget {
  const DragonesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =
        ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF17D4D4),
            brightness: Brightness.dark,
            primary: const Color(0xFF17D4D4),
          ),
          scaffoldBackgroundColor: const Color(0xFF101820),
          textTheme: GoogleFonts.montserratTextTheme(
            ThemeData.dark().textTheme,
          ).apply(bodyColor: Colors.white, displayColor: Colors.white),
          useMaterial3: true,
        ).copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(foregroundColor: Colors.black),
          ),
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dragones F.C. | Coapa',
      theme: theme,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const double _appBarHeight = 76;

  final ScrollController _scroll = ScrollController();
  final _heroKey = GlobalKey();
  final _escuelaKey = GlobalKey();
  final _porterosKey = GlobalKey();
  final _costosKey = GlobalKey();
  final _femenilKey = GlobalKey();
  final _ubicacionKey = GlobalKey();
  final _contactoKey = GlobalKey();

  /// Scroll preciso a una sección, descontando la altura del appbar
  void _goTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null || !_scroll.hasClients) return;

    final box = ctx.findRenderObject() as RenderBox;
    final y = box.localToGlobal(Offset.zero).dy; // posición en pantalla
    final paddingTop = MediaQuery.of(context).padding.top;
    final target = (_scroll.offset + y - (_appBarHeight + paddingTop + 8))
        .clamp(0.0, _scroll.position.maxScrollExtent);

    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('Inicio', () => _goTo(_heroKey)),
      _NavItem('Escuela', () => _goTo(_escuelaKey)),
      _NavItem('Porteros', () => _goTo(_porterosKey)),
      _NavItem('Costos', () => _goTo(_costosKey)),
      _NavItem('Femenil Libre', () => _goTo(_femenilKey)),
      _NavItem('Ubicación', () => _goTo(_ubicacionKey)),
      _NavItem('Contacto', () => _goTo(_contactoKey)),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(_appBarHeight),
        child: Material(
          // ← fondo real y elevación del appbar
          color: const Color(0xFF0D141A),
          elevation: 8,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LayoutBuilder(
                builder: (context, cons) {
                  return Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logo_dragones.jpg',
                            height: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'DRAGONES F.C.',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 26,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...items.map(
                            (i) => TextButton(
                              onPressed: i.onTap,
                              child: Text(
                                i.label,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          FilledButton(
                            onPressed: () => _goTo(_contactoKey),
                            child: const Text('INSCRÍBETE'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroSection(key: _heroKey, onCta: () => _goTo(_contactoKey)),
                _EscuelaSection(key: _escuelaKey),
                const _DividerWave(),
                _PorterosSection(key: _porterosKey),
                const _DividerWave(flip: true),
                _CostosSection(key: _costosKey),
                _FemenilLibreSection(key: _femenilKey),
                _UbicacionSection(key: _ubicacionKey),
                _ContactoSection(key: _contactoKey),
                const _Footer(),
              ],
            ),
          ),
          const _FloatingContact(),
        ],
      ),
    );
  }
}

/* ===================== HERO ===================== */

class _HeroSection extends StatelessWidget {
  final VoidCallback onCta;
  const _HeroSection({super.key, required this.onCta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E1B22), Color(0xFF111E27)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (ctx, c) {
              final isWide = c.maxWidth > 860;
              final titleSize = _clamp(c.maxWidth * 0.12, 36, 84);
              final subtitleSize = _clamp(c.maxWidth * 0.024, 14, 20);
              final logoHeight = _clamp(c.maxWidth * 0.28, 160, 320);

              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: isWide
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: isWide
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: Text(
                            'DRAGONES F.C.',
                            style: GoogleFonts.bebasNeue(
                              fontSize: titleSize,
                              letterSpacing: 3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coapa, MX • Escuela de Fútbol',
                          textAlign: isWide ? TextAlign.left : TextAlign.center,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: isWide
                              ? WrapAlignment.start
                              : WrapAlignment.center,
                          children: [
                            FilledButton.tonal(
                              onPressed: onCta,
                              child: const Text('Inscríbete ahora'),
                            ),
                            OutlinedButton(
                              onPressed: onCta,
                              child: const Text(
                                'Pedir más info',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24, height: 24),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/logo_dragones.jpg',
                        height: logoHeight,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ===================== SECCIONES ===================== */

class _EscuelaSection extends StatelessWidget {
  const _EscuelaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Escuela de Fútbol',
      subtitle: 'Varonil y Femenil',
      icon: Icons.sports_soccer,
      children: const [
        _Bullet(
          'Centro de iniciación deportiva. “Especialistas en categorías infantiles”.',
        ),
        _Bullet('Edades: de 6 a 18 años.'),
        _Bullet(
          'Entrenamientos: Lunes / Miércoles / Viernes de 5:00 PM a 7:00 PM.',
        ),
      ],
    );
  }
}

class _PorterosSection extends StatelessWidget {
  const _PorterosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Porteros',
      subtitle: 'Escuela oficial de porteros · HO Soccer México',
      icon: Icons.sports_handball,
      children: const [
        _TagRow(
          tags: [
            'Motricidad',
            'Velocidad',
            'Fuerza',
            'Técnica',
            'Entrenamiento funcional',
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Entrenamientos especializados en todas las partes físicas y técnicas para porteros.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class _CostosSection extends StatelessWidget {
  const _CostosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Costos',
      subtitle: 'Mensualidad',
      icon: Icons.payments,
      headerWidget: const _PriceCard(),
      children: const [
        SizedBox(height: 16),
        _Bullet('Extras: Entrenamientos personalizados.'),
        _Bullet('Extras: Entrenamiento funcional dirigido al fútbol.'),
      ],
    );
  }
}

class _FemenilLibreSection extends StatelessWidget {
  const _FemenilLibreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Categoría Femenil Libre',
      subtitle: 'De 19 a 25 años',
      icon: Icons.woman,
      children: const [
        Text(
          'Programa especial de alto rendimiento y proyección competitiva para jugadoras entre 19 y 25 años.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class _UbicacionSection extends StatelessWidget {
  const _UbicacionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Ubicación',
      subtitle: 'Cómo llegar',
      icon: Icons.place,
      children: const [
        _Bullet('Dep. de los Electricistas.'),
        _Bullet('Calz. del Hueso 380, Granjas Coapa.'),
        _Bullet('Campo 3–5. Ciudad de México.'),
      ],
    );
  }
}

class _ContactoSection extends StatelessWidget {
  const _ContactoSection({super.key});

  static final Uri _mail = Uri.parse(
    'mailto:dragonesfc@ejemplo.mx?subject=Información',
  );

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Contacto e Inscripciones',
      subtitle: '¡Únete a Dragones F.C.!',
      icon: Icons.connect_without_contact,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          children: [
            FilledButton.icon(
              onPressed: () =>
                  launchUrl(kWhatsAppUri, mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.chat),
              label: const Text('WhatsApp'),
            ),
            OutlinedButton.icon(
              onPressed: () => launchUrl(kTelUri),
              icon: const Icon(Icons.call),
              label: const Text(
                'Llamar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => launchUrl(_mail),
              icon: const Icon(Icons.email_outlined),
              label: const Text(
                'Correo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Opacity(
          opacity: 0.7,
          child: Text(
            'Horarios de atención: Lun–Vie, 10:00–19:00 hrs.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

/* ===================== COMPONENTES BASE ===================== */

class _Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;
  final Widget? headerWidget;

  const _Section({
    required this.title,
    required this.icon,
    this.subtitle,
    required this.children,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final vertical = w < 420 ? 40.0 : 60.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D141A), Color(0xFF111E27)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, c) {
                  final titleSize = _clamp(c.maxWidth * 0.06, 28, 48);
                  return Row(
                    children: [
                      Icon(icon, size: 24, color: const Color(0xFF17D4D4)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: GoogleFonts.bebasNeue(
                              fontSize: titleSize,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: const TextStyle(color: Colors.white70)),
              ],
              if (headerWidget != null) ...[
                const SizedBox(height: 18),
                headerWidget!,
              ],
              const SizedBox(height: 18),
              DefaultTextStyle(
                style: const TextStyle(fontSize: 16, color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Color(0xFF17D4D4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  final List<String> tags;
  const _TagRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (t) => Chip(
              label: Text(t, style: const TextStyle(color: Colors.white)),
              side: const BorderSide(color: Color(0xFF17D4D4)),
              backgroundColor: const Color(0xFF0E1B22),
            ),
          )
          .toList(),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final isWide = c.maxWidth > 520;
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0B1217),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF17D4D4).withOpacity(.5)),
            boxShadow: const [BoxShadow(blurRadius: 16, color: Colors.black54)],
          ),
          padding: const EdgeInsets.all(20),
          child: Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: isWide
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mensualidad',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$720.00 MXN',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isWide) const SizedBox(width: 12, height: 12),
              if (isWide)
                const Flexible(
                  child: Text(
                    'Inscripción sin costo en temporada de lanzamiento',
                    style: TextStyle(color: Colors.white60),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DividerWave extends StatelessWidget {
  final bool flip;
  const _DividerWave({this.flip = false});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipY: flip,
      child: Container(
        height: 32,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF101820), Color(0xFF0E1B22)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  static const int year = 2025;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: const Color(0xFF0B1217),
      child: Center(
        child: Column(
          children: [
            Image.asset('assets/images/logo_dragones.jpg', height: 40),
            const SizedBox(height: 8),
            Text(
              '© ${_Footer.year} Dragones F.C. · Coapa, MX',
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingContact extends StatelessWidget {
  const _FloatingContact();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton.extended(
        onPressed: () =>
            launchUrl(kWhatsAppUri, mode: LaunchMode.externalApplication),
        icon: const Icon(Icons.chat),
        label: const Text('WhatsApp'),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final VoidCallback onTap;
  _NavItem(this.label, this.onTap);
}
