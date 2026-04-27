import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/app_routes.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;

  const AppNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (isTablet) {
      return _BrutalistNavigationRail(currentIndex: currentIndex);
    }
    return _BrutalistBottomNav(currentIndex: currentIndex);
  }

  static void navigateTo(BuildContext context, int index) {
    final routes = [AppRoutes.homeScreen, AppRoutes.settingsScreen];
    if (index < routes.length) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (route) => false,
      );
    }
  }
}

class _BrutalistBottomNav extends StatelessWidget {
  final int currentIndex;

  const _BrutalistBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFF000000), width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'HOME',
                isActive: currentIndex == 0,
                onTap: () => AppNavigation.navigateTo(context, 0),
              ),
              Container(width: 2, height: 64, color: const Color(0xFFE0E0E0)),
              _NavItem(
                icon: Icons.tune_outlined,
                activeIcon: Icons.tune,
                label: 'EVENTS',
                isActive: currentIndex == 1,
                onTap: () => AppNavigation.navigateTo(context, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0xFFF5FF00).withAlpha(80),
        highlightColor: const Color(0xFFF5FF00).withAlpha(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: 22,
                color: isActive
                    ? const Color(0xFF000000)
                    : const Color(0xFF888888),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFF000000)
                    : const Color(0xFF888888),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: isActive ? 16 : 0,
              height: isActive ? 3 : 0,
              color: const Color(0xFF000000),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrutalistNavigationRail extends StatelessWidget {
  final int currentIndex;

  const _BrutalistNavigationRail({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFF000000), width: 2)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _RailItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'HOME',
            isActive: currentIndex == 0,
            onTap: () => AppNavigation.navigateTo(context, 0),
          ),
          const SizedBox(height: 8),
          _RailItem(
            icon: Icons.tune_outlined,
            activeIcon: Icons.tune,
            label: 'EVENTS',
            isActive: currentIndex == 1,
            onTap: () => AppNavigation.navigateTo(context, 1),
          ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _RailItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFFF5FF00).withAlpha(80),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF5FF00) : Colors.transparent,
          border: isActive
              ? const Border(
                  left: BorderSide(color: Color(0xFF000000), width: 3),
                )
              : null,
        ),
        child: Column(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: const Color(0xFF000000),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 8,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: const Color(0xFF000000),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
