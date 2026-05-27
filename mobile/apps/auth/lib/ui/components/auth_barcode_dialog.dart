import 'package:barcode_widget/barcode_widget.dart';
import 'package:ente_auth/theme/colors.dart';
import 'package:ente_auth/theme/ente_theme.dart';
import 'package:flutter/material.dart';

class AuthBarcodeDialog extends StatelessWidget {
  final String data;
  final String title;
  final String? subtitle;
  final String dialogTitle;

  const AuthBarcodeDialog({
    super.key,
    required this.data,
    required this.title,
    this.subtitle,
    this.dialogTitle = 'Barcode',
  });

  @override
  Widget build(BuildContext context) {
    final enteTextTheme = getEnteTextTheme(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dialogBackgroundColor = isDark
        ? const Color(0xFF212121)
        : theme.colorScheme.surface;
    final closeBgColor = isDark
        ? const Color(0xFF292929)
        : const Color(0xFFF5F5F7);
    final closeIconColor = isDark ? theme.colorScheme.onSurface : textBaseLight;

    final dialogTitleStyle = theme.textTheme.titleLarge?.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.7)
          : Colors.grey.withValues(alpha: 0.5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          decoration: BoxDecoration(
            color: dialogBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: isDark
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  )
                : null,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dialogTitle, style: dialogTitleStyle),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: closeBgColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: closeIconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: enteTextTheme.largeBold.copyWith(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null &&
                            subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: enteTextTheme.small.copyWith(
                              color: Colors.black.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 24),
                        BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: data,
                          width: double.infinity,
                          height: 100,
                          errorBuilder: (context, error) => Center(
                            child: Text(error),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
