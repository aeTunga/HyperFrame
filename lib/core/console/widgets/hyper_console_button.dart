import 'package:flutter/material.dart';

import 'hyper_console_sheet.dart';

/// HyperConsole Button
///
/// Floating button with smart gesture handling:
/// - **Tap**: Opens HyperConsole debug sheet (using Overlay)
/// - **Long Press + Drag**: Repositions the button
///
/// Visual feedback shows when button is being dragged.
///
/// **Architecture:**
/// - Uses Overlay system (no Navigator dependency)
/// - Wrapped in RepaintBoundary for proper layering
/// - Has elevation to ensure it renders on top
class HyperConsoleButton extends StatefulWidget {
  const HyperConsoleButton({super.key});

  @override
  State<HyperConsoleButton> createState() => _HyperConsoleButtonState();
}

class _HyperConsoleButtonState extends State<HyperConsoleButton>
    with SingleTickerProviderStateMixin {
  // Position of the button (bottom-left by default)
  late Offset _position;
  late Size _screenSize;

  // Drag state
  bool _isDragging = false;

  // Animation controller for visual feedback
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize scale animation for drag feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;

    // Initialize position to bottom-left corner
    _position = Offset(
      16, // 16px margin from left edge
      _screenSize.height - 120, // Above normal FAB position
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isDragging = true;
    });
    _scaleController.forward();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (_isDragging) {
      setState(() {
        // Update position based on drag, keeping button within screen bounds
        _position = Offset(
          details.localPosition.dx.clamp(0.0, _screenSize.width - 56),
          details.localPosition.dy.clamp(0.0, _screenSize.height - 56),
        );
      });
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isDragging = false;
    });
    _scaleController.reverse();
  }

  void _onTap(BuildContext context) {
    // Only open console if not dragging
    if (!_isDragging && mounted) {
      // Context now has Navigator access since button is inside MaterialApp
      HyperConsoleSheet.show(context);

      // Debug log to verify tap is received
      debugPrint('🎯 HyperConsole button tapped - opening sheet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: RepaintBoundary(
        // Force button into its own rendering layer for proper z-index
        child: PhysicalModel(
          // Add elevation to ensure button is on top
          color: Colors.transparent,
          elevation: 16,
          borderRadius: BorderRadius.circular(28),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, // CRITICAL: Ensures tap detection
            onTap: () {
              debugPrint('🎯 Tap gesture detected on HyperConsole button');
              _onTap(context);
            },
            onLongPressStart: (details) {
              debugPrint('🎯 Long press detected on HyperConsole button');
              _onLongPressStart(details);
            },
            onLongPressMoveUpdate: _onLongPressMoveUpdate,
            onLongPressEnd: _onLongPressEnd,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isDragging ? _scaleAnimation.value : 1.0,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 8, // Additional Material elevation
                    shape: const CircleBorder(),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _isDragging
                            ? theme.colorScheme.secondary.withValues(alpha: 0.9)
                            : theme.colorScheme.primary.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: _isDragging ? 0.5 : 0.3,
                            ),
                            blurRadius: _isDragging ? 16 : 8,
                            offset: Offset(0, _isDragging ? 8 : 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isDragging
                            ? Icons.drag_indicator
                            : Icons.developer_mode,
                        color: theme.colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
