import 'dart:math';

import 'package:ente_auth/l10n/l10n.dart';
import 'package:ente_auth/theme/colors.dart';
import 'package:ente_auth/theme/ente_theme.dart';
import 'package:ente_components/ente_components.dart' hide textBaseLight;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthQrDialog extends StatefulWidget {
  final String data;
  final String title;
  final String? subtitle;
  final String dialogTitle;

  const AuthQrDialog({
    super.key,
    required this.data,
    required this.title,
    this.subtitle,
    this.dialogTitle = 'Transfer QR Code',
  });

  @override
  State<AuthQrDialog> createState() => _AuthQrDialogState();
}

class _AuthQrDialogState extends State<AuthQrDialog> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double qrSize = min(screenWidth - 80, 300.0);
    final enteTextTheme = getEnteTextTheme(context);

    // QR text color - always black for scanability
    const qrTextColor = textBaseLight;

    return Semantics(
      identifier: 'auth_qr_sheet',
      child: BottomSheetComponent(
        title: widget.dialogTitle,
        closeTooltip: context.l10n.close,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.62,
          ),
          child: SingleChildScrollView(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.sheet),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: qrBoxColor),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Transform.rotate(
                          angle: -4 * pi / 180,
                          child: Image.asset(
                            'assets/qr_logo.png',
                            height: qrSize * 0.19,
                            width: qrSize * 0.19,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(qrSize * 0.07),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: qrSize * 0.03),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: qrSize - 72,
                              ),
                              child: Text(
                                widget.title,
                                style: enteTextTheme.largeBold.copyWith(
                                  color: qrTextColor,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.subtitle?.isNotEmpty == true) ...[
                              const SizedBox(height: Spacing.xs),
                              Text(
                                widget.subtitle!,
                                style: enteTextTheme.small.copyWith(
                                  color: qrTextColor.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'TRANSFER QR CODE',
                                style: enteTextTheme.smallBold.copyWith(
                                  color: accentColor,
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            SizedBox(height: qrSize * 0.05),
                            QrImageView(
                              data: widget.data,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: accentColor,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: qrTextColor,
                              ),
                              version: QrVersions.auto,
                              size: qrSize,
                            ),
                            SizedBox(height: qrSize * 0.07),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SvgPicture.asset(
                                'assets/svg/app-logo.svg',
                                height: 16,
                                colorFilter: const ColorFilter.mode(
                                  accentColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
