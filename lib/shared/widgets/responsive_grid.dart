import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Responsive Grid Widget
///
/// Demonstrates responsive layout that adapts to device width:
/// - Phone (< 600px): 2 columns
/// - Tablet (600-900px): 3 columns
/// - Desktop (> 900px): 4 columns
///
/// This proves that HyperFrame's device simulation accurately reflects
/// different screen sizes and responsive breakpoints.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    // Determine column count based on width
    int columns;
    String deviceCategory;

    if (width < 600) {
      columns = 2;
      deviceCategory = 'Phone';
    } else if (width < 900) {
      columns = 3;
      deviceCategory = 'Tablet';
    } else {
      columns = 4;
      deviceCategory = 'Desktop';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$deviceCategory Mode - $columns Columns',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Responsive Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return _buildGridCard(context, index);
          },
        ),
      ],
    );
  }

  Widget _buildGridCard(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    // Generate varied colors
    final colors = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
      colorScheme.errorContainer,
    ];

    final color = colors[index % colors.length];

    return Card(
      elevation: 1,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Card ${index + 1} tapped!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(index),
                size: 32,
                color: _getIconColor(index, colorScheme),
              ),
              const SizedBox(height: 8),
              Text(
                'Card ${index + 1}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getIconColor(index, colorScheme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.thumb_up,
      Icons.bolt,
      Icons.eco,
      Icons.wb_sunny,
      Icons.water_drop,
      Icons.local_fire_department,
    ];
    return icons[index % icons.length];
  }

  Color _getIconColor(int index, ColorScheme colorScheme) {
    final colors = [
      colorScheme.onPrimaryContainer,
      colorScheme.onSecondaryContainer,
      colorScheme.onTertiaryContainer,
      colorScheme.onErrorContainer,
    ];
    return colors[index % colors.length];
  }
}
