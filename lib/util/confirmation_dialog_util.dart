import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/colors/text_styles.dart';

class ConfirmationDialogUtil {
  Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: kColorStylePrimary0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title, style: kTestStyleBoldText20),
          content: Text(
            message,
            style: kTestStyleMediumText14.copyWith(
              color: kColorStyleSecondinaryDark400,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorStyleErrorDark500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(
                          0,
                          48,
                        ), // altura fixa, largura vem do Expanded
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                        onConfirm?.call();
                      },
                      child: Text(confirmLabel, style: kTestStyleBoldText16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                        onCancel?.call();
                      },
                      child: Text(cancelLabel, style: kTestStyleBoldText16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
