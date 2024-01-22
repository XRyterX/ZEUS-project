import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class IklanBanner extends StatefulWidget {
  @override
  _IklanBannerState createState() => _IklanBannerState();
}

class _IklanBannerState extends State<IklanBanner> {
  late BannerAd _bannerAd;
  bool _isBannerReady = false;
  bool isAdEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerReady = true;
          });
        }),
        request: AdRequest());
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isBannerReady && isAdEnabled)
      return Container(
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd),
      );
    else
      return SizedBox.shrink();
  }
}
