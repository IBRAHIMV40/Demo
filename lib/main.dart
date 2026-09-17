import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const AdMobTestApp());
}

class AdMobTestApp extends StatelessWidget {
  const AdMobTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdMob Test',
      theme: ThemeData(useMaterial3: true),
      home: const AdTestPage(),
    );
  }
}

class AdTestPage extends StatefulWidget {
  const AdTestPage({super.key});

  @override
  State<AdTestPage> createState() => _AdTestPageState();
}

class _AdTestPageState extends State<AdTestPage> {
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;

  InterstitialAd? _interstitialAd;
  bool _interstitialReady = false;

  static const String bannerTestId =
      'ca-app-pub-3940256099942544/9214589741';

  static const String interstitialTestId =
      'ca-app-pub-3940256099942544/1033173712';

  @override
  void initState() {
    super.initState();
    _loadBanner();
    _loadInterstitial();
  }

  void _loadBanner() {
    final ad = BannerAd(
      adUnitId: bannerTestId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _bannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) setState(() => _bannerLoaded = false);
          debugPrint('Banner failed: $error');
        },
      ),
    );

    _bannerAd = ad;
    ad.load();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialTestId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _loadInterstitial();
            },
          );
          if (mounted) setState(() {});
        },
        onAdFailedToLoad: (error) {
          _interstitialReady = false;
          debugPrint('Interstitial failed: $error');
          if (mounted) setState(() {});
        },
      ),
    );
  }

  void _showInterstitial() {
    final ad = _interstitialAd;
    if (ad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interstitial is still loading.')),
      );
      return;
    }
    ad.show();
    _interstitialAd = null;
    _interstitialReady = false;
    setState(() {});
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MovieNest AdMob Test')),
      body: Column(
        children: [
          const SizedBox(height: 28),
          const Icon(Icons.ads_click, size: 64),
          const SizedBox(height: 12),
          const Text(
            'AdMob Test App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'This project uses Google-provided test ad units. '
              'Do not replace them with live IDs until you are ready to publish.',
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: _showInterstitial,
            child: Text(
              _interstitialReady
                  ? 'Show Interstitial Test Ad'
                  : 'Loading Interstitial...',
            ),
          ),
          const Spacer(),
          if (_bannerLoaded && _bannerAd != null)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
