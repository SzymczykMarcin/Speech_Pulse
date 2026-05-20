import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../debug_log.dart';

const supportDeveloperProductId = 'support_developer_small';

class SupportPurchaseService extends ChangeNotifier {
  SupportPurchaseService({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  ProductDetails? _supportProduct;
  bool _loading = true;
  bool _storeAvailable = false;
  bool _purchaseInProgress = false;
  String? _message;

  ProductDetails? get supportProduct => _supportProduct;
  bool get loading => _loading;
  bool get purchaseInProgress => _purchaseInProgress;
  bool get canPurchase =>
      !_loading &&
      !_purchaseInProgress &&
      _storeAvailable &&
      _supportProduct != null;
  String? get message => _message;

  Future<void> load() async {
    _purchaseSubscription ??= _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: _handlePurchaseStreamError,
    );

    _loading = true;
    _message = null;
    notifyListeners();

    try {
      _storeAvailable = await _inAppPurchase.isAvailable();
      if (!_storeAvailable) {
        _supportProduct = null;
        _message = 'Google Play Billing is not available on this device.';
        return;
      }

      final response = await _inAppPurchase.queryProductDetails({
        supportDeveloperProductId,
      });
      if (response.error != null) {
        _supportProduct = null;
        _message = response.error!.message;
        appDebugLog('Support purchase query error: ${response.error}');
        return;
      }

      _supportProduct = response.productDetails.isEmpty
          ? null
          : response.productDetails.first;
      if (_supportProduct == null) {
        _message =
            'Support purchase will appear after the Google Play product is configured.';
        appDebugLog(
          'Support purchase product not found: ${response.notFoundIDs.join(', ')}',
        );
      }
    } catch (error) {
      _supportProduct = null;
      _message = 'Support purchase is unavailable right now.';
      appDebugLog('Support purchase load failed: $error');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> buySupport() async {
    final product = _supportProduct;
    if (!canPurchase || product == null) {
      return;
    }

    _purchaseInProgress = true;
    _message = null;
    notifyListeners();

    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } catch (error) {
      _purchaseInProgress = false;
      _message = 'Could not start the Google Play purchase.';
      appDebugLog('Support purchase start failed: $error');
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.productID != supportDeveloperProductId) {
        continue;
      }

      if (purchase.status == PurchaseStatus.pending) {
        _purchaseInProgress = true;
        _message = 'Purchase pending...';
      } else if (purchase.status == PurchaseStatus.error) {
        _purchaseInProgress = false;
        _message = purchase.error?.message ?? 'Purchase was not completed.';
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _purchaseInProgress = false;
        _message = 'Thank you for supporting Speech Pulse.';
      } else if (purchase.status == PurchaseStatus.canceled) {
        _purchaseInProgress = false;
        _message = 'Purchase canceled.';
      }

      await _completePurchaseIfNeeded(purchase);
    }

    notifyListeners();
  }

  void _handlePurchaseStreamError(Object error) {
    _purchaseInProgress = false;
    _message = 'Support purchase is unavailable right now.';
    appDebugLog('Support purchase stream failed: $error');
    notifyListeners();
  }

  Future<void> _completePurchaseIfNeeded(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) {
      return;
    }

    try {
      await _inAppPurchase.completePurchase(purchase);
    } catch (error) {
      _purchaseInProgress = false;
      _message = 'Could not finish the Google Play purchase.';
      appDebugLog('Support purchase completion failed: $error');
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
