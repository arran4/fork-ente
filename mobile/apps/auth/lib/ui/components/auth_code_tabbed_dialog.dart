import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:ente_auth/l10n/l10n.dart';
import 'package:ente_auth/theme/colors.dart';
import 'package:ente_auth/theme/ente_theme.dart';
import 'package:ente_components/ente_components.dart' hide textBaseLight;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthCodeTabbedDialog extends StatefulWidget {
  final ValueListenable<String> codeNotifier;
  final String title;
  final String? subtitle;
  final int initialTabIndex;
  final String dialogTitle;

  const AuthCodeTabbedDialog({
    super.key,
    required this.codeNotifier,
    required this.title,
    this.subtitle,
    this.initialTabIndex = 0,
    this.dialogTitle = 'Code',
  });

  @override
  State<AuthCodeTabbedDialog> createState() => _AuthCodeTabbedDialogState();
}

class _AuthCodeTabbedDialogState extends State<AuthCodeTabbedDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double qrSize = min(screenWidth - 100, 260.0);
    final enteTextTheme = getEnteTextTheme(context);
    final theme = Theme.of(context);

    const qrTextColor = textBaseLight;

    return Semantics(
      identifier: 'auth_code_tabbed_sheet',
      child: BottomSheetComponent(
        title: widget.dialogTitle,
        closeTooltip: context.l10n.close,
        content: ValueListenableBuilder<String>(
          valueListenable: widget.codeNotifier,
          builder: (context, codeValue, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: theme.colorScheme.primary,
                      ),
                      labelColor: theme.colorScheme.onPrimary,
                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                      labelStyle: enteTextTheme.smallBold.copyWith(
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.qr_code, size: 18),
                          text: 'QR Code',
                        ),
                        Tab(
                          icon: Icon(Icons.barcode_reader, size: 18),
                          text: 'Barcode',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.65,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
                                    SizedBox(height: qrSize * 0.02),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: qrSize - 40,
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
                                    SizedBox(height: qrSize * 0.05),
                                    // 1. QR / Barcode at the top
                                    SizedBox(
                                      height: qrSize,
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          // Tab 1: QR Code
                                          Center(
                                            child: QrImageView(
                                              data: codeValue.isNotEmpty ? codeValue : '000000',
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
                                          ),
                                          // Tab 2: Barcode (1D)
                                          Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: BarcodeWidget(
                                                barcode: Barcode.code128(),
                                                data: codeValue.isNotEmpty ? codeValue : '000000',
                                                width: qrSize,
                                                height: qrSize * 0.65,
                                                drawText: false,
                                                color: qrTextColor,
                                                errorBuilder: (context, error) => Center(
                                                  child: Text(
                                                    error,
                                                    style: const TextStyle(color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: qrSize * 0.05),
                                    // 2. Number being encoded display below the QR/Barcode
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: accentColor.withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'CODE',
                                            style: enteTextTheme.smallBold.copyWith(
                                              color: accentColor,
                                              fontSize: 11,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            codeValue.isNotEmpty ? codeValue : '------',
                                            style: enteTextTheme.largeBold.copyWith(
                                              color: textBaseLight,
                                              fontSize: 28,
                                              letterSpacing: 3,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: qrSize * 0.04),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
