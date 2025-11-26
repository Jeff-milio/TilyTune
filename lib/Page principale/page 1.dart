import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../acceuil/acceuil.dart';
import '../liste/liste.dart';
import '../moi/moi.dart';
import '../musiquePlayerPage/MiniPlayer.dart';
import '../notice/notice.dart';
import '../parametre/parametre.dart';

// Nouvelle icône animée avec un effet de pulsation
class PulsingIcon extends StatefulWidget {
  final IconData iconData;
  final double size;
  final Color color;

  const PulsingIcon({
    super.key,
    required this.iconData,
    this.size = 28,
    this.color = Colors.white70,
  });

  @override
  State<PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.4,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.slowMiddle));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(widget.iconData, size: widget.size, color: widget.color),
    );
  }
}

// --- Classe principale Page1 ---

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  final Color _activeColor = const Color(0xFFFFE3BB);
  final Color _inactiveColor = Color(0xFFE3E3E3);

  List<Widget> _buildScreens() {
    return [
      const acceuil(),
      Liste(),
      Moi(),
      const notice(),
      const Parametre(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const ImageIcon(AssetImage("assets/icon/tente.png")),
        title: "Acceuil",
        activeColorPrimary: _activeColor,
        inactiveColorPrimary: _inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.music_note_list),
        title: "Listes",
        activeColorPrimary: _activeColor,
        inactiveColorPrimary: _inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: PulsingIcon(iconData: Icons.person_pin, color: _inactiveColor),
        inactiveIcon: PulsingIcon(
          iconData: Icons.person_pin,
          color: _inactiveColor,
        ),
        title: "Moi",
        activeColorPrimary: _activeColor,
        inactiveColorPrimary: _inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell_solid),
        title: "Notification",
        activeColorPrimary: _activeColor,
        inactiveColorPrimary: _inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_sharp),
        title: "Parametre",
        activeColorPrimary: _activeColor,
        inactiveColorPrimary: _inactiveColor,
      ),
    ];
  }

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _selectTab(int i) {
    setState(() {
      _controller.index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _navBarsItems();
    const double bottomNavTotalHeight = 100;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: items,
            backgroundColor: Colors.transparent,
            navBarHeight: 0,
            hideNavigationBarWhenKeyboardAppears: true,
            stateManagement: true,
            confineToSafeArea: true,
            navBarStyle: NavBarStyle.style15,
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 350),
                curve: Curves.easeInOut,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: true,
                duration: Duration(milliseconds: 300),
              ),
            ),
          ),

          Positioned(
            left: 13,
            right: 13,
            bottom: bottomNavTotalHeight, // Positionné juste au-dessus de ta nav bar
            child: const MiniPlayer(),

          ),
          // --- NavBar Glass ---
          Positioned(
            left: 13,
            right: 13,
            bottom: 5,
            child: SafeArea(
              top: false,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final selected = _controller.index == index;

                        final Widget iconToDisplay = selected
                            ? (item.inactiveIcon ?? item.icon)
                            : (item.inactiveIcon ?? item.icon);

                        // ---- Cercle glass uniquement autour de l'icône active ----
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => _selectTab(index),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: selected ? 50 : 60,
                                  height: selected ? 50 : 35,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.white.withOpacity(0.09)
                                        : Colors.transparent,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: selected
                                          ? Colors.white.withOpacity(0)
                                          : Colors.transparent,
                                      width: 1,
                                    ),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: index == 2
                                        ? iconToDisplay
                                        : IconTheme(
                                            data: IconThemeData(
                                              color: selected
                                                  ? _activeColor
                                                  : _inactiveColor,
                                              size: 28,
                                            ),
                                            child: iconToDisplay,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.title ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    backgroundColor: Colors.transparent,
                                    color: selected
                                        ? _activeColor
                                        : _inactiveColor,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
